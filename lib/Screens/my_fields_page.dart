import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sports_complex.dart'; // Import the SportsComplex model
import 'add_new_field.dart';
import 'field_detail_page.dart'; // Import the FieldDetailPage
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

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
        final List<dynamic> complexesData = responseData['allComplex'];

        setState(() {
          complexes = complexesData
              .map((complex) => SportsComplex.fromJson(complex))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load complexes');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle the error accordingly
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

          // Refresh data or handle the added field
          fetchComplexes();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
