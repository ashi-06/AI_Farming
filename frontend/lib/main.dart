import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register_page/HomeStartingpage.dart';
import 'package:register_page/homepage.dart';
import 'package:register_page/signup.dart';
import 'package:register_page/login.dart';
import 'package:register_page/rainfall_prediction_page.dart';
import 'package:register_page/yield_prediction_page.dart';
import 'package:register_page/top_5_crop_recommendation_page.dart';
import 'package:register_page/ml_page.dart'; // Import MLPage here.
import 'package:register_page/dl_page.dart';

class Routes {
  static const String signup = 'signup';
  static const String login = 'login';
  static const String home = 'home';
  static const String rainfallPrediction = 'rainfallPrediction';
  static const String yieldPrediction = 'yieldPrediction';
  static const String top5CropRecommendation = 'top5CropRecommendation';
  static const String mlPage = 'mlPage'; // Added route for MLPage.
  static const String dlPage = 'dlPage';
  static const String HomeStartingpage = 'HomeStartingpage'; // Added route for HomeStartingpage.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _getInitialScreen(User? user) {
    if (user != null) {
      return const HomePage(); // Skip email verification and OTP
    } else {
      return const Home(); // Navigate to HomeStartingpage if user is not logged in.
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getInitialScreen(user), // Ensure initial screen is based on user status.
      routes: {
        Routes.HomeStartingpage: (context) => const Home(), // HomeStartingpage
        Routes.signup: (context) => const Signup(),
        Routes.login: (context) => const Login(),
        Routes.home: (context) => const HomePage(),
        Routes.rainfallPrediction: (context) => RainfallPrediction(),
        Routes.yieldPrediction: (context) => YieldPrediction(),
        Routes.top5CropRecommendation: (context) => CropPredictionPage(),
        Routes.mlPage: (context) => MLDashboardScreen(), // Route for MLPage
        Routes.dlPage: (context) => const DLPage(), // Route for DLPage
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Page not found')),
        ),
      ),
    );
  }
}
