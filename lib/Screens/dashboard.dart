import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Pending Requests and Upcoming Bookings
    final List<Map<String, String>> pendingRequests = [
      {
        'field': 'Complex A',
        'date': '2024-09-25',
        'time': '10:00 AM - 12:00 PM',
        'user': 'John Doe',
      },
      {
        'field': 'Complex B',
        'date': '2024-09-26',
        'time': '02:00 PM - 04:00 PM',
        'user': 'Jane Smith',
      },
    ];

    final List<Map<String, String>> upcomingBookings = [
      {
        'field': 'Complex A',
        'date': '2024-09-30',
        'time': '12:00 PM - 02:00 PM',
        'user': 'Michael Johnson',
      },
      {
        'field': 'Complex C',
        'date': '2024-10-01',
        'time': '03:00 PM - 05:00 PM',
        'user': 'Emily Davis',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        backgroundColor: Colors.blue, // Change AppBar color to blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pending Requests Section
              const Text(
                'Pending Requests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Blue accent for title
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: Colors.blue[50], // Light blue background for cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5, // Slight elevation for shadow
                    child: ListTile(
                      title: Text(
                        pendingRequests[index]['field']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Blue for field name
                        ),
                      ),
                      subtitle: Text(
                        '${pendingRequests[index]['date']} • ${pendingRequests[index]['time']} \nRequested by: ${pendingRequests[index]['user']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            color: Colors.green[400],
                            onPressed: () {
                              // Accept request logic here
                            },
                            tooltip: 'Accept',
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            color: Colors.red[400],
                            onPressed: () {
                              // Reject request logic here
                            },
                            tooltip: 'Reject',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Upcoming Bookings Section
              const Text(
                'Upcoming Bookings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Blue accent for title
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingBookings.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: Colors.blue[50], // Light blue background for cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5, // Slight elevation for shadow
                    child: ListTile(
                      title: Text(
                        upcomingBookings[index]['field']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Blue for field name
                        ),
                      ),
                      subtitle: Text(
                        '${upcomingBookings[index]['date']} • ${upcomingBookings[index]['time']} \nBooked by: ${upcomingBookings[index]['user']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
