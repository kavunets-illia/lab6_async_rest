import 'package:flutter/material.dart';
import 'screens/travel_screen.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Туристичний додаток',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const TravelScreen(),
    );
  }
}
