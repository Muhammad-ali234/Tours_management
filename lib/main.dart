import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/model.dart';
import 'package:toursapp/splash_screen.dart';
import 'package:toursapp/tourdata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TourData(), // Provide your state management class here
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tour Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TourManagementApp(), // Display splash screen initially
      ),
    );
  }
}

class TourManagementApp extends StatelessWidget {
  const TourManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(), // Display splash screen initially
    );
  }
}
