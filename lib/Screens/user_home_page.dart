import 'package:flutter/material.dart';
import '../models/sports_complex.dart'; // Import the SportsComplex class
import '../screens/sports_complex_list.dart';
import '../Screens/profile_page.dart'; // Import the SportsComplexList widget
import '../Screens/bookings_page.dart'; // Import the SportsComplexList widget

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

class HomePage extends StatelessWidget {
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

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Booking App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePage(), // Replace with your profile page widget
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
                // Navigate to home page
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Bookings'),
              onTap: () {
                // Navigate to bookings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BookingsPage(), // Replace with your bookings page widget
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
      body: SportsComplexList(complexes: complexes),
    );
  }
}
