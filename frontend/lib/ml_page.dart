import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register_page/rainfall_prediction_page.dart';
import 'package:register_page/yield_prediction_page.dart';
import 'package:register_page/top_5_crop_recommendation_page.dart';

class MLDashboardScreen extends StatelessWidget {
  // Firebase sign out function (if needed in the future)
  Future<void> handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, '/home');
    } catch (error) {
      print(error);
    }
  }

  // Navigation functions with MaterialPageRoute
  void navigateToRainfallPred(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  RainfallPrediction()),
    );
  }

  void navigateToCropPred(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CropPredictionPage()),
    );
  }

  void navigateToYieldPred(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  YieldPrediction()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom Navbar
          Container(
            height: 65,
            color: Color(0xFF003300),
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                Text(
                  'ML DASHBOARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    // Rainfall Prediction
                    GestureDetector(
                      onTap: () => navigateToRainfallPred(context),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, top: 5, left: 7, right: 7), // Added left and right margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // Reduced border radius
                          image: DecorationImage(
                            image: AssetImage('assets/Rainfall1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 250, // Reduced height
                        width: MediaQuery.of(context).size.width * 0.9, // Reduced width to make space for margin
                        child: Center(
                          child: Text(
                            'Rainfall Prediction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, // Reduced font size
                              fontFamily: 'Oleo',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Yield Prediction
                    GestureDetector(
                      onTap: () => navigateToYieldPred(context),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15), // Added left and right margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/yield3.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 250, // Reduced height
                        width: MediaQuery.of(context).size.width * 0.9, // Reduced width to make space for margin
                        child: Center(
                          child: Text(
                            'Yield Prediction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Oleo',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Crop Prediction
                    GestureDetector(
                      onTap: () => navigateToCropPred(context),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10, left: 15, right: 15), // Added left and right margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/crop1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 250, // Reduced height
                        width: MediaQuery.of(context).size.width * 0.9, // Reduced width to make space for margin
                        child: Center(
                          child: Text(
                            'Crop Prediction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Oleo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
