import 'package:flutter/material.dart';
import 'package:sporthub/Screens/dashboard.dart';
import 'package:sporthub/Screens/my_fields_page.dart';
import 'screens/profile_page.dart'; // Import the ProfilePage widget
import 'screens/bookings_page.dart'; // Import the MyBookingsPage widget
import 'screens/login.dart'; // Import the LoginPage widget
import 'screens/register.dart'; // Import the RegisterPage widget
import 'screens/player_home_page.dart'; // Import the new PlayerHomePage

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
      home: const LoginPage(), // Set LoginPage as the default page
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/player/home': (context) => const PlayerHomePage(),
        '/player/bookings': (context) => const PlayerBookingsPage(),
        '/player/profile': (context) => const PlayerProfilePage(),
        '/manager/home': (context) => const ManagerHomePage(),
        '/manager/complex': (context) => ManagerComplexPage(),
      },
    );
  }
}
