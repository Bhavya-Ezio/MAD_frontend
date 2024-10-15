import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporthub/models/sports_complex.dart';
import 'dart:convert';
import 'sports_complex_list.dart'; // Import SportsComplexList widget
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  _PlayerHomePageState createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  List<SportsComplex> complexes = [];

  @override
  void initState() {
    super.initState();
    fetchComplexes();
  }

  Future<void> fetchComplexes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('https://mad-backend-x7p2.onrender.com/complex/all'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> complexesData = jsonData['allComplex'];
      setState(() {
        complexes = complexesData
            .map((complex) => SportsComplex.fromJson(complex))
            .toList();
      });
    } else {
      throw Exception('Failed to load complexes');
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear the token from SharedPreferences
      await prefs.remove('jwtToken');
      Navigator.of(context).pushReplacementNamed('/login');

      // Navigate back to the login screen without back button
    } catch (e) {
      print('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SportsHub',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/player/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Bookings'),
              onTap: () {
                Navigator.pushNamed(context, '/player/bookings');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _logout(); // Call the logout function on tap
              },
            ),
          ],
        ),
      ),
      body: complexes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SportsComplexList(
              complexes: complexes,
              onComplexTap: (String complexId) {
                Navigator.pushNamed(
                  context,
                  '/complex/detail',
                  arguments: complexId,
                );
              },
            ),
    );
  }
}
