import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';
import '../../models/application.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

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
        stream: firestoreService.streamApplicantsForStartup(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final applicants = snapshot.data ?? [];

          if (applicants.isEmpty) {
            return const EmptyState(icon: Icons.people_outline, message: 'No applicants yet');
          }

          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final app = applicants[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(app.studentName),
                  subtitle: Text('Applied for ${app.opportunityTitle}'),
                  trailing: DropdownButton<String>(
                    value: app.status,
                    underline: const SizedBox(),
                    items: ['pending', 'accepted', 'rejected']
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s, style: TextStyle(color: _statusColor(s))),
                            ))
                        .toList(),
                    onChanged: (value) async {
                      if (value == null) return;
                      await firestoreService.updateApplicationStatus(app.applicationId, value);
                    },
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