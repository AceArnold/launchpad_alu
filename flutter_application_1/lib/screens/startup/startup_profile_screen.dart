import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_button.dart';
import '../../models/startup.dart';

class StartupProfileScreen extends StatefulWidget {
  const StartupProfileScreen({super.key});

  @override
  State<StartupProfileScreen> createState() => _StartupProfileScreenState();
}

class _StartupProfileScreenState extends State<StartupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  bool _initialized = false;

  void _handleSave(String startupId) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _firestoreService.updateStartupProfile(
        startupId,
        _nameController.text.trim(),
        _descController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      body: StreamBuilder<Startup?>(
        stream: _firestoreService.streamStartup(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final startup = snapshot.data;
          if (startup == null) {
            return const Center(child: Text('Startup profile not found.'));
          }

          // Only fill the text fields once, so typing isn't overwritten by live stream updates
          if (!_initialized) {
            _nameController.text = startup.name;
            _descController.text = startup.description;
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Chip(
                      avatar: Icon(
                        startup.isVerified ? Icons.verified : Icons.hourglass_empty,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        startup.isVerified ? 'Verified ALU Startup' : 'Pending Verification',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: startup.isVerified ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Startup Name', border: OutlineInputBorder()),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: startup.category,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Save Changes',
                    onPressed: () => _handleSave(startup.startupId),
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}