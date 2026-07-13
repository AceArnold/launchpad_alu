import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';
import '../../models/application.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final firestoreService = FirestoreService();

    return Scaffold(
      body: StreamBuilder<List<Application>>(
        stream: firestoreService.streamMyApplications(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final applications = snapshot.data ?? [];

          if (applications.isEmpty) {
            return const EmptyState(icon: Icons.inbox_outlined, message: 'No applications yet');
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(app.opportunityTitle),
                  subtitle: Text(
                      'Applied ${app.appliedAt.day}/${app.appliedAt.month}/${app.appliedAt.year}'),
                  trailing: Chip(
                    label: Text(app.status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: _statusColor(app.status),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}