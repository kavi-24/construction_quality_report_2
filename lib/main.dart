import 'package:construction_quality_report_2/screens/splash_screen.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DB.instance,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        // routes ?
      ),
    );
  }
}