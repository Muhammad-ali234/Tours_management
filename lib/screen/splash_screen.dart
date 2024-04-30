import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD:lib/screen/splash_screen.dart
import 'package:toursapp/provider/tourdata.dart';
import 'package:toursapp/screen/login_screen.dart';
=======
import 'package:toursapp/login_screen.dart';
import 'package:toursapp/tourdata.dart';
>>>>>>> 4f49188fb36ca33d690c615cb200af797c28ac64:lib/splash_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TourData(context), // Replace YourProvider with your actual provider
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Adjust width and height of the image here
              Image(
                image: AssetImage('assets/logo.png'),
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Wardet AI Khan Tours L.L.C Branch: 1',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
