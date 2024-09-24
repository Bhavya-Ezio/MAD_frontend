import 'package:flutter/material.dart';
import '../models/sports_complex.dart'; // Import the SportsComplex model
import 'add_new_field.dart';
import 'field_detail_page.dart'; // Import the FieldDetailPage

class MyFieldsPage extends StatelessWidget {
  final List<SportsComplex> complexes = [
    SportsComplex(
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Complex A',
      pricePerHour: 50.0,
      location: 'Location A',
    ),
    SportsComplex(
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Complex B',
      pricePerHour: 60.0,
      location: 'Location B',
    ),
    // Add more SportsComplex instances here
  ];

  MyFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fields'),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView.builder(
        itemCount: complexes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: Colors.blue[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              leading: Image.network(complexes[index].imageUrl),
              title: Text(
                complexes[index].name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text(
                '${complexes[index].location}\nPrice: \$${complexes[index].pricePerHour}/hour',
                style: const TextStyle(color: Colors.blueGrey),
              ),
              onTap: () {
                // Navigate to the Field Detail Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FieldDetailPage(field: complexes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the AddFieldPage and wait for the result (new field)
          await Navigator.push<SportsComplex>(
            context,
            MaterialPageRoute(builder: (context) => const AddFieldPage()),
          );

          // If a new field was added, add it to the list and update the UI
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
