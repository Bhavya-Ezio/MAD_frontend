// player_home_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporthub/models/sports_complex.dart';
import 'dart:convert';
import 'sports_complex_list.dart'; // Import SportsComplexList widget

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
    final response = await http
        .get(Uri.parse('https://mad-backend-x7p2.onrender.com/complex/all'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> complexesData =
          jsonData['allComplex']; // Extract the 'allComplex' list
      setState(() {
        complexes = complexesData
            .map((complex) => SportsComplex.fromJson(complex))
            .toList();
      });
    } else {
      throw Exception('Failed to load complexes');
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
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: complexes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SportsComplexList(complexes: complexes),
    );
  }
}
