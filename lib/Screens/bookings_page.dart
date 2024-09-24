import 'package:flutter/material.dart';

class PlayerBookingsPage extends StatelessWidget {
  const PlayerBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No bookings yet!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
