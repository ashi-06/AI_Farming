import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LandClassification extends StatefulWidget {
  @override
  _LandClassificationState createState() => _LandClassificationState();
}

class _LandClassificationState extends State<LandClassification> {
  File? _selectedImage;
  String? predictedLabel;
  String? confidence;

  // Function to pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        predictedLabel = null;
        confidence = null;
      });
    }
  }

  // Function to send the image for prediction
  Future<void> predictLand() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    final url =
        Uri.parse('http://192.168.29.37:5000/predict_land'); // Server URL

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(
            await http.MultipartFile.fromPath('file', _selectedImage!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(await response.stream.bytesToString());

        if (data is Map && data.containsKey('error')) {
          setState(() {
            predictedLabel = 'Error: ${data['error']}';
            confidence = null; // No confidence in case of an error
          });
        } else if (data is Map && data.containsKey('predicted_label')) {
          double? conf = data['confidence'] != null ? data['confidence'] : 0.0;

          // Check if the confidence is below 70% (0.7 threshold)
          if (conf != null && conf < 0.9) {
            setState(() {
              predictedLabel = 'The image does not appear to be a Land image.';
              confidence = 'Confidence is below 90';
            });
          } else {
            setState(() {
              predictedLabel = data['predicted_label'];
              confidence = conf != null
                  ? '${(conf * 100).toStringAsFixed(2)}%'
                  : null; // Display confidence as percentage
            });
          }
        } else {
          setState(() {
            predictedLabel = 'No crops predicted';
            confidence = null;
          });
        }
      } else {
        setState(() {
          predictedLabel = 'Failed to get prediction: ${response.statusCode}';
          confidence = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Land Classification',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch to match width
            children: [
              // Display selected image
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.contain,
                )
              else
                Text(
                  'No image selected.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              SizedBox(height: 20),

              // Button to select an image
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Select Image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // Button to predict land classification
              ElevatedButton(
                onPressed: predictLand,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Predict Land',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),

              // Display prediction results
              if (predictedLabel != null && confidence != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center-align text horizontally
                  children: [
                    Text(
                      'Predicted Label:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$predictedLabel',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Confidence:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$confidence%',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LandClassification(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 18),
      ),
    ),
  ));
}
