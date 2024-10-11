import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sporthub/models/sports_complex.dart';
import './add_new_field.dart';
import './field_detail_page.dart';

class ManagerComplexPage extends StatefulWidget {
  const ManagerComplexPage({super.key});

  @override
  _ManagerComplexPageState createState() => _ManagerComplexPageState();
}

class _ManagerComplexPageState extends State<ManagerComplexPage> {
  List<SportsComplex> complexes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplexes();
  }

  Future<void> fetchComplexes() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('https://mad-backend-x7p2.onrender.com/complex/client'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the Bearer token here
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('allComplex')) {
          final List<dynamic> complexesData = responseData['allComplex'];

          setState(() {
            complexes = complexesData
                .map((complex) => SportsComplex.fromJson(complex))
                .toList();
            isLoading = false; // Hide loading indicator
          });
        } else {
          throw Exception('Response does not contain "allComplex" key');
        }
      } else {
        throw Exception('Failed to load complexes: ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading complexes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fields'),
        backgroundColor: Colors.blue[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complexes.isEmpty
              ? const Center(child: Text('No complexes available'))
              : ListView.builder(
                  itemCount: complexes.length,
                  itemBuilder: (context, index) {
                    final complex = complexes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          // Navigate to FieldDetailPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FieldDetailPage(
                                complexId: complex.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image at the top of the card
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                complex.images.isNotEmpty
                                    ? complex.images[0]
                                    : 'https://via.placeholder.com/150',
                                height: 200.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Complex Name
                                  Text(
                                    complex.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Location
                                  Text(
                                    complex.city,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Price per hour
                                  Text(
                                    'Price: ₹${complex.pricePerHour}/hour',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Sports List (if available)
                                  complex.sports.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Available Sports:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Wrap(
                                              spacing: 5,
                                              children: complex.sports
                                                  .map((sport) => Chip(
                                                        label: Text(
                                                          sport.name,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        )
                                      : const Text(
                                          'No sports available',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new field action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFieldPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
