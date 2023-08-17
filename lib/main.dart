import 'package:flutter/material.dart';
import 'package:project/signup_page.dart';
import 'package:project/startup_page.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await SharedPreferences.getInstance(); 
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: StartupPage(), // Set StartupPage as the initial screen
    );
  }
}