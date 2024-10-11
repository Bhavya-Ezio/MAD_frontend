import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sports_complex.dart';

class FieldDetailPage extends StatefulWidget {
  final String complexId;

  const FieldDetailPage({super.key, required this.complexId});

  @override
  _FieldDetailPageState createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  late Future<SportsComplex> complexDetails;

  @override
  void initState() {
    super.initState();
    complexDetails = fetchComplexDetails(widget.complexId);
  }

  Future<SportsComplex> fetchComplexDetails(String complexId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mad-backend-x7p2.onrender.com/complex/detail/$complexId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SportsComplex.fromJson(data['complexDetails']);
      } else {
        throw Exception('Failed to load complex details');
      }
    } catch (e) {
      throw Exception('Failed to load complex details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Details'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<SportsComplex>(
        future: complexDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading complex details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No details available'));
          } else {
            final field = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        field.images.isNotEmpty ? field.images[0] : '',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Complex Name
                  Center(
                    child: Text(
                      field.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location and Price Card
                  _buildCard(
                    title: 'Location & Price',
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.location_on, 'Location',
                            '${field.address}, ${field.city}'),
                        _buildInfoRow(Icons.attach_money, 'Price',
                            '₹${field.pricePerHour}/hour'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Address, Phone, Email, Opening & Closing Times Card
                  _buildCard(
                    title: 'Contact Details',
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.home, 'Address', field.address),
                        _buildInfoRow(Icons.phone, 'Phone', field.phone),
                        _buildInfoRow(Icons.email, 'Email', field.email),
                        _buildInfoRow(Icons.access_time, 'Opening Time',
                            field.openingTime),
                        _buildInfoRow(Icons.access_time, 'Closing Time',
                            field.closingTime),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    field.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sports Offered
                  const Text(
                    'Sports Offered:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: field.sports
                        .map((sport) => Chip(
                              label: Text(sport.name),
                              backgroundColor: Colors.blueAccent,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Manager Info Card
                  if (field.manager != null) ...[
                    _buildCard(
                      title: 'Manager Information',
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.person, 'Name',
                              field.manager!.name ?? "N/A"),
                          _buildInfoRow(Icons.email, 'Email',
                              field.manager?.email ?? "N/A"),
                        ],
                      ),
                    ),
                  ] else if (field.managerId != null) ...[
                    _buildCard(
                      title: 'Manager Information',
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.person, 'Manager ID',
                              field.managerId!),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Helper widget to build each row of information
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create a card with a title and child
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8.0,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
