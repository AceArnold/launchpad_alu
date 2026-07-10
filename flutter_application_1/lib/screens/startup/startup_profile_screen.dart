import 'package:flutter/material.dart';
import '../../services/fake_data.dart';
import '../../widgets/app_button.dart';

class StartupProfileScreen extends StatefulWidget {
  const StartupProfileScreen({super.key});

  @override
  State<StartupProfileScreen> createState() => _StartupProfileScreenState();
}

class _StartupProfileScreenState extends State<StartupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: FakeData.myStartup.name);
    _descController = TextEditingController(text: FakeData.myStartup.description);
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: replace with real Firestore update to startups/{startupId}
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final startup = FakeData.myStartup;

    return Scaffold(
      appBar: AppBar(title: const Text('Startup Profile')),
      body: SingleChildScrollView(
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
              AppButton(label: 'Save Changes', onPressed: _handleSave, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}