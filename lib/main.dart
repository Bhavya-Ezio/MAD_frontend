import 'package:flutter/material.dart';
import 'screens/sports_complex_list.dart'; // Import the SportsComplexList widget
import 'screens/profile_page.dart'; // Import the ProfilePage widget
import 'Screens/bookings_page.dart'; // Import the MyBookingsPage widget
import 'screens/login.dart'; // Import the LoginPage widget
import 'screens/register.dart';
import 'models/sports_complex.dart'; // Import the RegisterPage widget

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
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/my-bookings': (context) => BookingsPage(),
      },
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
        title: const Text(
          'SportsHub',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/profile'); // Navigate to profile page
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
                Navigator.pushNamed(
                    context, '/my-bookings'); // Navigate to bookings page
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(
                    context, '/login'); // Navigate to login page
              },
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.pushNamed(
                    context, '/register'); // Navigate to register page
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
