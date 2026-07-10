import 'package:flutter/material.dart';
import '../../services/fake_data.dart';
import '../../widgets/empty_state.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({super.key});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  Color _statusColor(String status) {
    switch (status) {
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicants = FakeData.myApplicants;

    return Scaffold(
      appBar: AppBar(title: const Text('Applicants')),
      body: applicants.isEmpty
          ? const EmptyState(icon: Icons.people_outline, message: 'No applicants yet')
          : ListView.builder(
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
                      onChanged: (value) {
                        // TODO: replace with real Firestore update to applications/{id}
                        setState(() {
                          FakeData.myApplicants[index] = FakeData.myApplicants[index];
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}