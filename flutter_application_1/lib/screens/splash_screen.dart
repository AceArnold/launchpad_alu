import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'student/student_shell.dart';
import 'startup/startup_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    // Small delay so the splash branding is actually visible, not just a flash
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    try {
      final appUser = await _authService.getCurrentUserProfile();

      if (!mounted) return;

      if (appUser == null) {
        // No one logged in — go to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Already logged in — skip straight to their home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                appUser.role == 'startup' ? const StartupShell() : const StudentShell(),
          ),
        );
      }
    } catch (e) {
      // If anything goes wrong (e.g. no network), fall back to Login
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 70, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'LaunchPad ALU',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}