import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../student/student_home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'student';
  bool _isLoading = false;

  void _handleSignup() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: replace with real FirebaseAuth.createUserWithEmailAndPassword
    // + write user doc to Firestore with uid, name, email, role
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  validator: (value) =>
                      (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  validator: (value) =>
                      (value == null || value.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 20),
                const Text('I am a:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Student'),
                        value: 'student',
                        groupValue: _role,
                        onChanged: (value) => setState(() => _role = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Startup'),
                        value: 'startup',
                        groupValue: _role,
                        onChanged: (value) => setState(() => _role = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Sign Up', onPressed: _handleSignup, isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}