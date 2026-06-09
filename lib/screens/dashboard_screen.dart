import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Add Student'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/addStudent',
              );
            },
          ),
          ListTile(
            title: const Text('View Students'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/students',
              );
            },
          ),
        ],
      ),
    );
  }
}
