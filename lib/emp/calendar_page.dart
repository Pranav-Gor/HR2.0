import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page'),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Calendar Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
