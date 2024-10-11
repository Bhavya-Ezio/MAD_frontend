import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sports_complex.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  AddFieldPageState createState() => AddFieldPageState();
}

class AddFieldPageState extends State<AddFieldPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _image; // Store the selected image
  String? _imageUrl; // Store the uploaded image URL
  List<Sport> _sports = [];
  List<String> _selectedSports = [];

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  Future<void> _fetchSports() async {
    try {
      final response = await http.get(
          Uri.parse('https://mad-backend-x7p2.onrender.com/common/sports'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          // Parse the sports data
          setState(() {
            _sports = (responseData['sports'] as List)
                .map((sport) => Sport.fromJson(sport))
                .toList();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch sports')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch sports')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching sports')),
      );
    }
  }

  void _showSportSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Sports'),
          content: SingleChildScrollView(
            child: Column(
              children: _sports.map((sport) {
                return CheckboxListTile(
                  title: Text(sport.name),
                  value: _selectedSports.contains(sport.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedSports.add(sport.id);
                      } else {
                        _selectedSports.remove(sport.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> submitNewField() async {
    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image')),
      );
      return;
    }

    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken') ?? '';

      // Create the new field data
      final fieldData = {
        "name": _nameController.text,
        "address": _addressController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "city": _cityController.text,
        "openingTime": _openingTimeController.text,
        "closingTime": _closingTimeController.text,
        "pricePerHour": double.parse(_pricePerHourController.text),
        "description": _descriptionController.text,
        "images": [_imageUrl],
        "sports": _selectedSports,
      };

      final response = await http.post(
        Uri.parse('https://mad-backend-x7p2.onrender.com/complex/add'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(fieldData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final newField = SportsComplex.fromJson(responseData['complex']);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Field added successfully!')),
        );

        // Navigate back to the Manager Complex page
        Navigator.pop(context, newField);
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Failed to add new field')),
        );
      }
    } catch (error) {
      print(error); // Print the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while adding the field')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/dgvslio7u/image/upload'),
      );

      request.fields['upload_preset'] = 'SportsHub';
      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(responseData.body);
        setState(() {
          _imageUrl = result['secure_url'];
        });
        print(_imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while uploading the image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Field'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputCard(
                title: 'Field Information',
                children: [
                  _buildTextField(_nameController, 'Field Name'),
                  const SizedBox(height: 16),
                  _buildTextField(_pricePerHourController, 'Price per Hour',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField(_descriptionController, 'Description',
                      maxLines: 3),
                ],
              ),
              const SizedBox(height: 16),

              _buildInputCard(
                title: 'Contact Information',
                children: [
                  _buildTextField(_addressController, 'Address'),
                  const SizedBox(height: 16),
                  _buildTextField(_phoneController, 'Phone',
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField(_emailController, 'Email',
                      keyboardType: TextInputType.emailAddress),
                ],
              ),
              const SizedBox(height: 16),

              _buildInputCard(
                title: 'Location & Timing',
                children: [
                  _buildTextField(_cityController, 'City'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      _openingTimeController, 'Opening Time (HH:MM)'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      _closingTimeController, 'Closing Time (HH:MM)'),
                ],
              ),
              const SizedBox(height: 20),

              // Sports Selection Button
              ElevatedButton(
                onPressed: _showSportSelectionDialog,
                child: const Text('Select Sports'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blue[800],
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

              // Display Selected Sports
              if (_selectedSports.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: _selectedSports.map((sportId) {
                      final sport = _sports.firstWhere((s) => s.id == sportId);
                      return Chip(
                        label: Text(sport.name),
                        onDeleted: () {
                          setState(() {
                            _selectedSports.remove(sportId);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 20),

              // Image Upload Button
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blue[800],
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _uploadImage(); // Upload the image first
                    await submitNewField(); // Then submit the field data
                  },
                  child: const Text('Add Field'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    backgroundColor: Colors.blue[800],
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildInputCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

// Sport model remains unchanged
class Sport {
  final String id;
  final String name;

  Sport({required this.id, required this.name});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'],
      name: json['name'],
    );
  }
}
