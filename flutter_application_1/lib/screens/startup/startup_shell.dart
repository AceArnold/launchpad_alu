import 'package:flutter/material.dart';
import 'startup_home_screen.dart';
import 'applicants_screen.dart';
import 'startup_profile_screen.dart';

class StartupShell extends StatefulWidget {
  const StartupShell({super.key});

  @override
  State<StartupShell> createState() => _StartupShellState();
}

class _StartupShellState extends State<StartupShell> {
  int _index = 0;

  final _screens = const [
    StartupHomeScreen(),
    ApplicantsScreen(),
    StartupProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work), label: 'Opportunities'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Applicants'),
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Profile'),
        ],
      ),
    );
  }
}