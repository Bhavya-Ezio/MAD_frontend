import 'package:flutter/material.dart';

class PlayerProfilePage extends StatelessWidget {
  const PlayerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ProfileContent(),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildProfileHeader(),
        const SizedBox(height: 20),
        _buildUserInfo(),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return const Center(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with user's profile picture URL
          ),
          SizedBox(height: 10),
          Text(
            'Om Desai',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
          Text(
            'Software Engineer',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: UserInfo(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            // Navigate to edit profile page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Updated parameter
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Edit Profile'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle logout
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Updated parameter
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildInfoRow('Phone', '+123 456 7890'),
        const SizedBox(height: 12),
        _buildInfoRow('Email', 'om.desai@example.com'),
        const SizedBox(height: 12),
        _buildInfoRow('Address', '123 Main Street, City, State'),
        const SizedBox(height: 12),
        _buildInfoRow('Membership Status', 'Gold Member'),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
