import 'package:flutter/material.dart';
import '../models/sports_complex.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  AddFieldPageState createState() => AddFieldPageState();
}

class AddFieldPageState extends State<AddFieldPage> {
  // Controllers to capture the input from the user
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Field'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image URL Input
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Field Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Price per hour Input
            TextField(
              controller: _pricePerHourController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price per Hour',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Location Input
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Create a new SportsComplex instance with the data
                final newField = SportsComplex(
                  imageUrl: _imageUrlController.text,
                  name: _nameController.text,
                  pricePerHour: double.parse(_pricePerHourController.text),
                  location: _locationController.text,
                );

                // Pop this page and pass the new field back to the previous page
                Navigator.pop(context, newField);
              },
              child: const Text('Add Field'),
            ),
          ],
        ),
      ),
    );
  }
}
