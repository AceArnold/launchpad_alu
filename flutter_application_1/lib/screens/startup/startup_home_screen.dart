import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';
import '../../models/opportunity.dart';
import '../../models/startup.dart';
import 'post_opportunity_screen.dart';

class StartupHomeScreen extends StatefulWidget {
  const StartupHomeScreen({super.key});

  @override
  State<StartupHomeScreen> createState() => _StartupHomeScreenState();
}

class _StartupHomeScreenState extends State<StartupHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      body: StreamBuilder<Startup?>(
        stream: _firestoreService.streamStartup(user.uid),
        builder: (context, startupSnapshot) {
          final startup = startupSnapshot.data;

          return StreamBuilder<List<Opportunity>>(
            stream: _firestoreService.streamMyOpportunities(user.uid),
            builder: (context, oppSnapshot) {
              if (oppSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final myOpportunities = oppSnapshot.data ?? [];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Opportunities',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (startup != null)
                          Chip(
                            avatar: Icon(
                              startup.isVerified ? Icons.verified : Icons.hourglass_empty,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: Text(
                              startup.isVerified ? 'Verified' : 'Pending',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: startup.isVerified ? Colors.green : Colors.orange,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: myOpportunities.isEmpty
                        ? const EmptyState(
                            icon: Icons.work_outline,
                            message: 'No opportunities posted yet',
                          )
                        : ListView.builder(
                            itemCount: myOpportunities.length,
                            itemBuilder: (context, index) {
                              final opp = myOpportunities[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(opp.title),
                                  subtitle: Text(opp.category),
                                  trailing: Chip(
                                    label: Text(
                                      opp.isOpen ? 'Open' : 'Closed',
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: opp.isOpen ? Colors.indigo : Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostOpportunityScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Post Opportunity'),
      ),
    );
  }
}