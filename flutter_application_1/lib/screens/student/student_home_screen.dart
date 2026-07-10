import 'package:flutter/material.dart';
import '../../services/fake_data.dart';
import '../../widgets/opportunity_card.dart';
import '../../models/opportunity.dart';
import 'opportunity_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Opportunity> filtered = FakeData.opportunities.where((o) {
      return o.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          o.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Discover Opportunities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No opportunities found'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final opp = filtered[index];
                      return OpportunityCard(
                        opportunity: opp,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpportunityDetailScreen(opportunity: opp),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}