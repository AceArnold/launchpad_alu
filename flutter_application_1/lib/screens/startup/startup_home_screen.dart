import 'package:flutter/material.dart';
import '../../services/fake_data.dart';
import '../../widgets/empty_state.dart';
import 'post_opportunity_screen.dart';

class StartupHomeScreen extends StatelessWidget {
  const StartupHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // only show opportunities belonging to this startup
    final myOpportunities = FakeData.opportunities
        .where((o) => o.startupId == FakeData.myStartup.startupId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Opportunities'),
        actions: [
          if (FakeData.myStartup.isVerified)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Chip(
                label: Text('Verified', style: TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
      body: myOpportunities.isEmpty
          ? const EmptyState(icon: Icons.work_outline, message: 'No opportunities posted yet')
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
                      label: Text(opp.isOpen ? 'Open' : 'Closed',
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: opp.isOpen ? Colors.indigo : Colors.grey,
                    ),
                  ),
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