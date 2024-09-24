import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import the http package
import '../models/sports_complex.dart'; // Import the SportsComplex class
import '../screens/sports_complex_list.dart';
import '../Screens/profile_page.dart';
import '../Screens/bookings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SportsComplex> complexes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplexData();
  }

  Future<void> fetchComplexData() async {
    final url = Uri.parse('https://mad-backend-x7p2.onrender.com/complex/all');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> complexesData = data['allComplex'];

        setState(() {
          complexes = complexesData.map((complex) {
            return SportsComplex(
              imageUrl: complex['images'][0], // Use the first image
              name: complex['name'],
              pricePerHour: complex['pricePerHour'].toDouble(),
              location: complex['city'],
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load complexes');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Booking App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayerProfilePage(),
                ),
              );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerBookingsPage(),
                  ),
                );
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SportsComplexList(complexes: complexes),
    );
  }
}
