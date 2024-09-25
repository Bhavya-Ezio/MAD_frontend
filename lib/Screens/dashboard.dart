import 'package:flutter/material.dart';

class ManagerHomePage extends StatelessWidget {
  const ManagerHomePage({super.key});

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
        title: const Text(
          'Manager Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the Home Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer, color: Colors.blue),
              title: const Text('Complexes'),
              onTap: () {
                Navigator.pushNamed(context, '/manager/complex');
                // Navigate to the Complexes Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: const Text('Bookings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the Bookings Page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
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
                  color: Colors.blueAccent,
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
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        pendingRequests[index]['field']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${pendingRequests[index]['date']} • ${pendingRequests[index]['time']} \nRequested by: ${pendingRequests[index]['user']}',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            color: Colors.green[400],
                            onPressed: () {
                              // Accept request logic here
                            },
                            tooltip: 'Accept',
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined),
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
                  color: Colors.blueAccent,
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
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        upcomingBookings[index]['field']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${upcomingBookings[index]['date']} • ${upcomingBookings[index]['time']} \nBooked by: ${upcomingBookings[index]['user']}',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
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
