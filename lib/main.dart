import 'package:flutter/material.dart';
import 'package:moolaxv2/services/service_locator.dart';

import 'ui/views/calculate_screen.dart';

void main() {
  //Setup Service Locator
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moola X V2',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalculateCurrencyScreen(),
    );
  }
}
