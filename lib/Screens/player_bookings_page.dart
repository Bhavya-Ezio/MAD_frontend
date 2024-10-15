import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlayerBookingsPage extends StatefulWidget {
  const PlayerBookingsPage({Key? key}) : super(key: key);

  @override
  _PlayerBookingsPageState createState() => _PlayerBookingsPageState();
}

class _PlayerBookingsPageState extends State<PlayerBookingsPage> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      final response = await http.get(
        Uri.parse(
            'https://mad-backend-x7p2.onrender.com/booking/player/requests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bookings = List<Map<String, dynamic>>.from(data['bookings']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  String formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(
                  child:
                      Text('No bookings yet!', style: TextStyle(fontSize: 18)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Bookings Overview',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Sport Complex')),
                            DataColumn(label: Text('Sport')),
                            DataColumn(label: Text('Start Time')),
                            DataColumn(label: Text('End Time')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Approval')),
                          ],
                          rows: bookings.map((booking) {
                            return DataRow(cells: [
                              DataCell(Text(booking['sportComplex']['name'])),
                              DataCell(Text(booking['sport']['name'])),
                              DataCell(
                                  Text(formatDateTime(booking['startTime']))),
                              DataCell(
                                  Text(formatDateTime(booking['endTime']))),
                              DataCell(Text(booking['status'])),
                              DataCell(Text(booking['approvalStatus'])),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
