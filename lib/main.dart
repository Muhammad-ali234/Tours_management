import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/provider/tourdata.dart';
import 'package:toursapp/screen/splash_screen.dart';
import 'package:toursapp/provider/table_headers.dart';

Future main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TourData(context),
          ),
          ChangeNotifierProvider(
            create: (context) => TableHeaders(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tour Management',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TourManagementApp(),
          // Display splash screen initially
        ));
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
