import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RainfallPrediction extends StatefulWidget {
  @override
  _RainfallPredictionState createState() => _RainfallPredictionState();
}

class _RainfallPredictionState extends State<RainfallPrediction> {
  String? year;
  String? selectedPlace;
  double? rainfallPrediction;
  bool isLoading = false;

  final List<Map<String, String>> states = [
    {'label': 'Andhra Pradesh', 'value': 'Andhra Pradesh'},
    {'label': 'Arunachal Pradesh', 'value': 'Arunachal Pradesh'},
    {'label': 'Assam', 'value': 'Assam'},
    {'label': 'Bihar', 'value': 'Bihar'},
    {'label': 'Chhattisgarh', 'value': 'Chhattisgarh'},
    {'label': 'Delhi', 'value': 'Delhi'},
    {'label': 'Goa', 'value': 'Goa'},
    {'label': 'Gujarat', 'value': 'Gujarat'},
    {'label': 'Haryana', 'value': 'Haryana'},
    {'label': 'Himachal Pradesh', 'value': 'Himachal Pradesh'},
    {'label': 'Jammu and Kashmir', 'value': 'Jammu and Kashmir'},
    {'label': 'Jharkhand', 'value': 'Jharkhand'},
    {'label': 'Karnataka', 'value': 'Karnataka'},
    {'label': 'Kerala', 'value': 'Kerala'},
    {'label': 'Madhya Pradesh', 'value': 'Madhya Pradesh'},
    {'label': 'Maharashtra', 'value': 'Maharashtra'},
    {'label': 'Manipur', 'value': 'Manipur'},
    {'label': 'Meghalaya', 'value': 'Meghalaya'},
    {'label': 'Mizoram', 'value': 'Mizoram'},
    {'label': 'Nagaland', 'value': 'Nagaland'},
    {'label': 'Odisha', 'value': 'Odisha'},
    {'label': 'Puducherry', 'value': 'Puducherry'},
    {'label': 'Punjab', 'value': 'Punjab'},
    {'label': 'Rajasthan', 'value': 'Rajasthan'},
    {'label': 'Sikkim', 'value': 'Sikkim'},
    {'label': 'Tamil Nadu', 'value': 'Tamil Nadu'},
    {'label': 'Telangana', 'value': 'Telangana'},
    {'label': 'Tripura', 'value': 'Tripura'},
    {'label': 'Uttar Pradesh', 'value': 'Uttar Pradesh'},
    {'label': 'Uttarakhand', 'value': 'Uttarakhand'},
    {'label': 'West Bengal', 'value': 'West Bengal'},
  ];

  Future<void> handlePredict() async {
    setState(() {
      isLoading = true;
      rainfallPrediction = null;
    });

    const API_URL = 'http://192.168.29.37:5000/predict_rainfall'; // Replace with correct IP

    try {
      final response = await http.post(
        Uri.parse(API_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year': year,
          'state': selectedPlace
        }),
      );

      final responseData = jsonDecode(response.body);
      setState(() {
        rainfallPrediction = responseData['predicted_rainfall'];
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Failed to get prediction from the server.'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/rainfallbackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Rainfall Prediction',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => year = value,
                    decoration: InputDecoration(
                      labelText: 'Enter Year (e.g., 2018)',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: Text('Select a State'),
                    value: selectedPlace,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlace = newValue;
                      });
                    },
                    items: states
                        .map<DropdownMenuItem<String>>((state) {
                          return DropdownMenuItem<String>(
                            value: state['value'],
                            child: Text(state['label']!),
                          );
                        })
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : handlePredict,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isLoading ? 'Predicting...' : 'Predict',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  if (rainfallPrediction != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Predicted Rainfall: ${rainfallPrediction!.toStringAsFixed(2)} mm',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
