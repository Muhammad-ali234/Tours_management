import 'package:flutter/material.dart';
import 'package:toursapp/model.dart';
import 'package:toursapp/splash_screen.dart';

void main() {
  runApp(const TourManagementApp());
}

class TourManagementApp extends StatelessWidget {
  const TourManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tour Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Display splash screen initially
    );
  }
}
