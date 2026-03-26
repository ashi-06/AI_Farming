import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: YieldPrediction(),
  ));
}

class YieldPrediction extends StatefulWidget {
  @override
  _YieldPredictionState createState() => _YieldPredictionState();
}

class _YieldPredictionState extends State<YieldPrediction> {
  TextEditingController yearController = TextEditingController();
  TextEditingController fertilizerController = TextEditingController();
  TextEditingController pesticideController = TextEditingController();
  TextEditingController rainfallController = TextEditingController();
  String? selectedPlace;
  String? selectedCrop;
  bool isLoading = false;
  String? yieldPrediction;

  final List<String> places = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Puducherry',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  final List<String> crops = [
    'Arecanut',
    'Arhar/Tur',
    'Bajra',
    'Banana',
    'Barley',
    'Black pepper',
    'Cardamom',
    'Cashewnut',
    'Castor seed',
    'Coconut',
    'Coriander',
    'Cotton(lint)',
    'Cowpea(Lobia)',
    'Dry chillies',
    'Garlic',
    'Ginger',
    'Gram',
    'Groundnut',
    'Guar seed',
    'Horse-gram',
    'Jowar',
    'Jute',
    'Khesari',
    'Linseed',
    'Maize',
    'Masoor',
    'Mesta',
    'Moong(Green Gram)',
    'Moth',
    'Niger seed',
    'Oilseeds total',
    'Onion',
    'Other Rabi pulses',
    'Other Cereals',
    'Other Kharif pulses',
    'Other Summer Pulses',
    'Peas & beans (Pulses)',
    'Potato',
    'Ragi',
    'Rapeseed & Mustard',
    'Rice',
    'Safflower',
    'Sannhamp',
    'Sesamum',
    'Small millets',
    'Soyabean',
    'Sugarcane',
    'Sunflower',
    'Sweet potato',
    'Tapioca',
    'Tobacco',
    'Turmeric',
    'Urad',
    'Wheat',
    'other oilseeds'
  ];

  Future<void> handlePredict() async {
    setState(() {
      isLoading = true;
      yieldPrediction = null;
    });

    // Input Validation
    if (yearController.text.isEmpty ||
        selectedPlace == null ||
        selectedCrop == null ||
        fertilizerController.text.isEmpty ||
        pesticideController.text.isEmpty ||
        rainfallController.text.isEmpty) {
      setState(() {
        yieldPrediction = 'Error: Please fill in all fields';
      });
      return;
    }

    // Ensure numeric fields are valid
    var year = int.tryParse(yearController.text);
    var fertilizer = double.tryParse(fertilizerController.text);
    var pesticide = double.tryParse(pesticideController.text);
    var rainfall = double.tryParse(rainfallController.text);

    if (year == null ||
        fertilizer == null ||
        pesticide == null ||
        rainfall == null) {
      setState(() {
        yieldPrediction = 'Error: Please enter valid numeric values';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.29.37:5000/predict_yield'), // Replace with your API URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'year': yearController.text,
          'state': selectedPlace,
          'crop': selectedCrop,
          'fertilizer': fertilizerController.text,
          'pesticide': pesticideController.text,
          'rainfall': rainfallController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          yieldPrediction =
              jsonDecode(response.body)['predicted_yield'].toString();
        });
      } else {
        setState(() {
          yieldPrediction = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        yieldPrediction = 'Error occurred: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Yieldbackground.png', // Your background image
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Yield Prediction',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter the Year ( Ex : 2018 )',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedPlace,
                        decoration: InputDecoration(
                          labelText: 'Select a place',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        items: places
                            .map((place) => DropdownMenuItem(
                                  value: place,
                                  child: Text(place),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPlace = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCrop,
                        decoration: InputDecoration(
                          labelText: 'Select a crop',
                          prefixIcon: Icon(Icons.nature),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        items: crops
                            .map((crop) => DropdownMenuItem(
                                  value: crop,
                                  child: Text(crop),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCrop = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: fertilizerController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount of Fertilizer Used',
                          prefixIcon: Icon(Icons.grain),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: pesticideController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount of Pesticide Used',
                          prefixIcon: Icon(Icons.local_florist),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: rainfallController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Annual Rainfall (mm)',
                          prefixIcon: Icon(Icons.cloud),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : handlePredict,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF003300),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Predict',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 20),
                      if (yieldPrediction != null)
                        Text(
                          'Predicted Yield: $yieldPrediction tons/ha',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
