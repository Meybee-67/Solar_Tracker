import 'package:flutter/material.dart';
import 'package:solar_tracker/connection/wifi-connecting.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor:Colors.white),
      home : ConnectionPage(),
    );
  }
}