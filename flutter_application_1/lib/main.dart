import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
// ignore: unused_import
import '../screens/student/student_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaunchPad ALU',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}