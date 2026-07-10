import 'package:flutter/material.dart';
import 'student_home_screen.dart';
import 'my_applications_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;

  final _screens = const [StudentHomeScreen(), MyApplicationsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Applications'),
        ],
      ),
    );
  }
}