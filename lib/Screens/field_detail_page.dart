import 'package:flutter/material.dart';
import '../models/sports_complex.dart'; // Import the SportsComplex model

class FieldDetailPage extends StatelessWidget {
  final SportsComplex field;

  const FieldDetailPage({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(field.name),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the field image
            Center(
              child: Image.network(
                field.imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              field.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${field.location}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${field.pricePerHour}/hour',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Add logic to book the field
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue button color
              ),
              child: const Text(
                'Edit Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
