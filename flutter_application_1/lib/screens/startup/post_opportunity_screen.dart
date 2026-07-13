import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_button.dart';
import '../../models/opportunity.dart';
import '../../services/firestore_service.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String _category = 'Software Engineering';
  bool _isLoading = false;

  final _categories = const [
    'Software Engineering',
    'Marketing',
    'Data Science',
    'Design',
    'Business',
    'Other',
  ];

  void _handlePost() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final startup = await _firestoreService.getStartup(user.uid);

      final opportunity = Opportunity(
        opportunityId: '', // Firestore auto-generates this
        startupId: user.uid,
        startupName: startup?.name ?? 'Unknown Startup',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _category,
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
        isOpen: true,
      );

      await _firestoreService.postOpportunity(opportunity);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opportunity posted!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an Opportunity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a title' : null,
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
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter a location' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Post Opportunity', onPressed: _handlePost, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}