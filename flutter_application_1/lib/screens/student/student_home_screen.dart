import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/empty_state.dart';
import '../../models/opportunity.dart';
import 'opportunity_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: StreamBuilder<List<Opportunity>>(
              stream: _firestoreService.streamAllOpportunities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allOpportunities = snapshot.data ?? [];
                final filtered = allOpportunities.where((o) {
                  return o.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      o.category.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    message: 'No opportunities found',
                  );
                }

                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}