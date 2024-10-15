import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<dynamic> approvedBookings = [];
  List<dynamic> rejectedBookings = [];
  List<dynamic> pendingBookings = [];
  List<dynamic> completedBookings = [];
  String activeTab = 'upcoming bookings';
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() {
      loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');
      final response = await http.get(
        Uri.parse('https://mad-backend-x7p2.onrender.com/booking/requests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final bookings = jsonResponse['bookingRequests'];
        final now = DateTime.now();

        approvedBookings = bookings
            .where((booking) =>
                booking['approvalStatus'] == 'Approved' &&
                DateTime.parse(booking['startTime']).isAfter(now))
            .toList();

        rejectedBookings = bookings
            .where((booking) => booking['approvalStatus'] == 'Rejected')
            .toList();

        pendingBookings = bookings
            .where((booking) => booking['approvalStatus'] == 'Pending')
            .toList();

        completedBookings = bookings
            .where((booking) =>
                booking['approvalStatus'] == 'Approved' &&
                DateTime.parse(booking['endTime']).isBefore(now))
            .toList();
      } else {
        setState(() {
          error = 'Failed to fetch bookings';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch bookings';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _handleAccept(String bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      final response = await http.put(
          Uri.parse(
              'https://mad-backend-x7p2.onrender.com/booking/accept/$bookingId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        setState(() {
          pendingBookings.removeWhere((booking) => booking['_id'] == bookingId);
          fetchBookings(); // Optionally refetch
        });
      } else {
        setState(() {
          error = 'Failed to accept booking';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to accept booking';
      });
    }
  }

  Future<void> _handleReject(String bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      final response = await http.put(
          Uri.parse(
              'https://mad-backend-x7p2.onrender.com/booking/reject/$bookingId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        setState(() {
          pendingBookings.removeWhere((booking) => booking['_id'] == bookingId);
          fetchBookings();
        });
      } else {
        setState(() {
          error = 'Failed to reject booking';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to reject booking';
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Bookings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _tabButton('Upcoming Bookings')),
                Expanded(child: _tabButton('Booking Requests')),
                Expanded(child: _tabButton('Completed Bookings')),
                Expanded(child: _tabButton('Rejected Bookings')),
              ],
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : error != null
                    ? Text(error!)
                    : Expanded(
                        child: activeTab == 'upcoming bookings'
                            ? _buildBookingList(approvedBookings, true)
                            : activeTab == 'booking requests'
                                ? _buildPendingRequests(pendingBookings)
                                : activeTab == 'completed bookings'
                                    ? _buildBookingList(
                                        completedBookings, false)
                                    : _buildBookingList(
                                        rejectedBookings, false),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          activeTab = title.toLowerCase();
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontWeight: activeTab == title.toLowerCase()
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBookingList(List<dynamic> bookings, bool isUpcoming) {
    if (bookings.isEmpty) {
      return Center(child: Text('No bookings found.'));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final startTime = DateTime.parse(booking['startTime']);
        final endTime = DateTime.parse(booking['endTime']);

        return ListTile(
          title: Text('${booking['sport']['name']} Booking'),
          subtitle: Text('Client: ${booking['user']['name']}'),
          trailing: Text(
              '${formatDate(startTime)} ${formatTime(startTime)} - ${formatTime(endTime)}'),
        );
      },
    );
  }

  Widget _buildPendingRequests(List<dynamic> bookings) {
    if (bookings.isEmpty) {
      return Center(child: Text('No pending requests.'));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final startTime = DateTime.parse(booking['startTime']);
        final endTime = DateTime.parse(booking['endTime']);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking['sport']['name']} Booking',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Client: ${booking['user']['name']}'),
                SizedBox(height: 5),
                Text('${formatDate(startTime)}'),
                Text('${formatTime(startTime)} - ${formatTime(endTime)}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleAccept(booking['_id']),
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleReject(booking['_id']),
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
