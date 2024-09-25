import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sports_complex.dart'; // Import the SportsComplex class
import 'package:shared_preferences/shared_preferences.dart';


class EnquiryPage extends StatefulWidget {
  final SportsComplex complex;

  const EnquiryPage({super.key, required this.complex});

  @override
  EnquiryPageState createState() => EnquiryPageState();
}

class EnquiryPageState extends State<EnquiryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  SportsComplex? _complexDetails;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchComplexDetails();
  }

  Future<void> fetchComplexDetails() async {
  try {
    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken') ?? ''; // Replace 'jwtToken' with your actual key

    final response = await http.get(
      Uri.parse('{{Api}}/complex/detail/${widget.complex.id}'),
      headers: {
        'Authorization': 'Bearer $token', // Add token to the request header
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        _complexDetails = SportsComplex.fromJson(jsonData['complex']);
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

  final startTime = DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _selectedTime.hour,
    _selectedTime.minute,
  ).toUtc().toIso8601String();

  final endTime = DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _selectedTime.hour + 1,
    _selectedTime.minute,
  ).toUtc().toIso8601String();

  final bookingData = {
    "sportComplexId": widget.complex.id,
    "sportId": _complexDetails?.sports[0].id ?? '',
    "startTime": startTime,
    "endTime": endTime,
    "bookingType": "Regular",
  };

  try {
    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken') ?? '';

    final response = await http.post(
      Uri.parse('{{Api}}/booking/add'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add token to the request header
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
      const SnackBar(content: Text('An error occurred while submitting the booking')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquire About ${widget.complex.name}'),
        backgroundColor: Colors.blue[700],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sports Complex: ${widget.complex.name}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price per hour: \$${widget.complex.pricePerHour.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${widget.complex.location}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  _complexDetails == null 
                    ? const CircularProgressIndicator()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          _complexDetails!.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildTextField(_nameController, 'Your Name'),
                        const SizedBox(height: 12),
                        _buildTextField(_phoneController, 'Your Phone Number'),
                        const SizedBox(height: 12),
                        _buildTextField(_sportController, 'Sport Type'),
                        const SizedBox(height: 12),
                        _buildDateField(),
                        const SizedBox(height: 12),
                        _buildTimeField(),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: submitBooking, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: const Text('Submit Booking',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      keyboardType: label == 'Your Phone Number'
          ? TextInputType.phone
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Date (YYYY-MM-DD)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
                _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
              });
            }
          },
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the booking date';
        }
        return null;
      },
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _timeController,
      decoration: InputDecoration(
        labelText: 'Time (HH:MM)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
            );
            if (pickedTime != null) {
              setState(() {
                _selectedTime = pickedTime;
                _timeController.text = pickedTime.format(context);
              });
            }
          },
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the booking time';
        }
        return null;
      },
    );
  }
}
