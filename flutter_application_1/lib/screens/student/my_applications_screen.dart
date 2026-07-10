import 'package:flutter/material.dart';
import '../../services/fake_data.dart';
import '../../widgets/empty_state.dart';

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
    final applications = FakeData.applications;

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: applications.isEmpty
          ? const EmptyState(icon: Icons.inbox_outlined, message: 'No applications yet')
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(app.opportunityTitle),
                    subtitle: Text('Applied ${app.appliedAt.day}/${app.appliedAt.month}/${app.appliedAt.year}'),
                    trailing: Chip(
                      label: Text(app.status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: _statusColor(app.status),
                    ),
                  ),
                );
              },
            ),
    );
  }
}