import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/opportunity.dart';
import '../../models/application.dart';
import '../../services/firestore_service.dart';

class OpportunityDetailScreen extends StatefulWidget {
  final Opportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  State<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isApplying = false;

  void _handleApply() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isApplying = true);

    try {
      final alreadyApplied = await _firestoreService.hasAlreadyApplied(
        user.uid,
        widget.opportunity.opportunityId,
      );

      if (alreadyApplied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already applied to this opportunity.')),
        );
        return;
      }

      final application = Application(
        applicationId: '', // Firestore auto-generates the real ID
        opportunityId: widget.opportunity.opportunityId,
        opportunityTitle: widget.opportunity.title,
        studentUid: user.uid,
        studentName: user.displayName ?? user.email ?? 'Student',
        startupId: widget.opportunity.startupId,
        status: 'pending',
        appliedAt: DateTime.now(),
      );

      await _firestoreService.applyToOpportunity(application);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunity = widget.opportunity;

    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              opportunity.startupName,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(label: Text(opportunity.category)),
                const SizedBox(width: 8),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 2),
                Text(opportunity.location, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const Divider(height: 32),
            const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(opportunity.description, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                ),
                onPressed: _isApplying ? null : _handleApply,
                child: _isApplying
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Apply Now', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}