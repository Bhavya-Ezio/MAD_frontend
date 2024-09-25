import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> submitNewField() async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken') ?? '';

      // Create the new field data
      final fieldData = {
        "name": _nameController.text,
        "imageUrl": _imageUrlController.text,
        "pricePerHour": double.parse(_pricePerHourController.text),
        "location": _locationController.text,
      };

      final response = await http.post(
        Uri.parse('{{Api}}/complex/add'), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the header
        },
        body: jsonEncode(fieldData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final newField = SportsComplex.fromJson(responseData['complex']);

        // Pop this page and pass the new field back to the previous page
        Navigator.pop(context, newField);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add new field')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while adding the field')),
      );
    }
  }

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
              onPressed: submitNewField,
              child: const Text('Add Field'),
            ),
          ],
        ),
      ),
    );
  }
}
