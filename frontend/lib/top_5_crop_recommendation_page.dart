import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropPredictionPage extends StatefulWidget {
  @override
  _CropPredictionPageState createState() => _CropPredictionPageState();
}

class _CropPredictionPageState extends State<CropPredictionPage> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _fertilizerController = TextEditingController();
  final TextEditingController _pesticideController = TextEditingController();

  String _selectedState = '';
  String _selectedSeason = '';
  bool _isLoading = false;
  String _prediction = '';

  List<String> states = [
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

  List<String> seasons = [
    'Kharif',
    'Rabi',
    'Autumn',
    'Winter',
    'Summer',
    'Whole Year'
  ];

  Future<void> _predictCrop() async {
    setState(() {
      _isLoading = true;
      _prediction = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.29.37:5000/predict_top_5_crops'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'year': _yearController.text,
          'state': _selectedState,
          'season': _selectedSeason,
          'area': _areaController.text,
          'fertilizer': _fertilizerController.text,
          'pesticide': _pesticideController.text,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map && data.containsKey('error')) {
          // Backend sent an error message
          setState(() {
            _prediction = 'Error: ${data['error']}';
          });
        } else if (data is List && data.isNotEmpty) {
          List<String> predictedCrops = [];
          for (var crop in data) {
            if (crop != null && crop['Crop'] != null) {
              predictedCrops.add(crop['Crop']);
            }
          }

          setState(() {
            _prediction = predictedCrops.isEmpty
                ? 'No crops predicted'
                : predictedCrops.join(', ');
          });
        } else {
          setState(() {
            _prediction = 'No crops predicted';
          });
        }
      } else {
        setState(() {
          _prediction = 'Failed to get prediction: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _prediction = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Prediction'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/cropbackground2.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Crop Prediction',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Year (Ex: 2018)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _selectedState.isEmpty ? null : _selectedState,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedState = newValue!;
                          });
                        },
                        items: states
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Select State'),
                        isExpanded: true,
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _selectedSeason.isEmpty ? null : _selectedSeason,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSeason = newValue!;
                          });
                        },
                        items: seasons
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Select Season'),
                        isExpanded: true,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Area (Hectares)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _fertilizerController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount of Fertilizer Used',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _pesticideController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount of Pesticide Used',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _predictCrop,
                        child: Text(_isLoading ? 'Predicting...' : 'Predict'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF003300), // Button color
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_prediction.isNotEmpty)
                        Text(
                          'Predicted Crops: $_prediction',
                          style: TextStyle(fontSize: 18, color: Colors.green),
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
