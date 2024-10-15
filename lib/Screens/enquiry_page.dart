import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sports_complex.dart';

class EnquiryPage extends StatefulWidget {
  final String complexId;

  const EnquiryPage({super.key, required this.complexId});

  @override
  EnquiryPageState createState() => EnquiryPageState();
}

class EnquiryPageState extends State<EnquiryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  String? _selectedSport;
  SportsComplex? _complexDetails;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchComplexDetails();
  }

  Future<void> fetchComplexDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken') ?? '';

      final response = await http.get(
        Uri.parse(
            'https://mad-backend-x7p2.onrender.com/complex/detail/${widget.complexId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _complexDetails = SportsComplex.fromJson(jsonData['complexDetails']);
          _selectedSport = _complexDetails?.sports.isNotEmpty == true
              ? _complexDetails!.sports[0].id
              : null; // Ensure there's a sport to select
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load complex details');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading complex details')),
      );
    }
  }

  Future<void> submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final bookingData = {
      "sportComplexId": widget.complexId,
      "sportId": _selectedSport,
      "startTime": _startTimeController.text,
      "endTime": _endTimeController.text,
      "bookingType": "Regular",
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken') ?? '';

      final response = await http.post(
        Uri.parse('https://mad-backend-x7p2.onrender.com/booking/add'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit booking')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting booking')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Page'),
        backgroundColor: const Color(0xFF0F4C75),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Complex Image
                      if (_complexDetails?.images.isNotEmpty == true)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            _complexDetails!.images[0],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Display Complex Details
                      Text(
                        'Complex: ${_complexDetails?.name ?? 'Loading...'}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Address: ${_complexDetails?.address ?? 'Loading...'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'City: ${_complexDetails?.city ?? 'Loading...'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Phone: ${_complexDetails?.phone ?? 'Loading...'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Email: ${_complexDetails?.email ?? 'Loading...'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Opening Hours: ${_complexDetails?.openingTime} - ${_complexDetails?.closingTime}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Price per Hour: ₹${_complexDetails?.pricePerHour ?? 0}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Display Available Sports
                      const Text(
                        'Available Sports:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _complexDetails?.sports
                                .map((sport) => Chip(
                                      label: Text(sport.name),
                                      backgroundColor: const Color(0xFF3282B8),
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                .toList() ??
                            [],
                      ),
                      const SizedBox(height: 20),

                      // Dropdown for Selecting Sport
                      DropdownButtonFormField<String>(
                        value: _selectedSport,
                        items: _complexDetails?.sports
                                .map((sport) => DropdownMenuItem(
                                      value: sport.id,
                                      child: Text(sport.name),
                                    ))
                                .toList() ??
                            [],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSport = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Sport',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor:
                              const Color(0xFFBBE1FA), // Light blue background
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a sport';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Start Time Input
                      _buildTimeInputField(
                        controller: _startTimeController,
                        label: 'Start Time',
                        context: context,
                      ),
                      const SizedBox(height: 10),

                      // End Time Input
                      _buildTimeInputField(
                        controller: _endTimeController,
                        label: 'End Time',
                        context: context,
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0F4C75),
                                    Color(0xFF3282B8),
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: submitBooking,
                                child: const Text(
                                  'Submit Booking',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTimeInputField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFBBE1FA), // Light blue background
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            controller.text = picked.format(context);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }
}
