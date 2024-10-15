import 'package:flutter/material.dart';
import '../models/sports_complex.dart'; // Import the SportsComplex class
import 'enquiry_page.dart'; // Import the EnquiryPage

class SportsComplexList extends StatefulWidget {
  final List<SportsComplex> complexes;
  final Function(String complexId) onComplexTap; // Callback function for complex selection

  const SportsComplexList({
    super.key, 
    required this.complexes, 
    required this.onComplexTap, // Ensure this is passed as a parameter
  });

  @override
  _SportsComplexListState createState() => _SportsComplexListState();
}

class _SportsComplexListState extends State<SportsComplexList> {
  List<SportsComplex> filteredComplexes = []; // Initialize with an empty list
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredComplexes = widget.complexes; // Initialize with all complexes
  }

  void filterComplexes(String query) {
    setState(() {
      searchQuery = query;
      filteredComplexes = widget.complexes.where((complex) {
        return complex.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: filterComplexes,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search complexes...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredComplexes.length,
            itemBuilder: (context, index) {
              final complex = filteredComplexes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      complex.images.isNotEmpty ? complex.images[0] : '', // Ensure image exists
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            complex.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price per hour: ₹ ${complex.pricePerHour.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ${complex.city}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Call the onComplexTap callback with the complex _id
                              widget.onComplexTap(complex.id);
                              
                              // Navigate to the EnquiryPage with complex.id
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnquiryPage(complexId: complex.id),
                                ),
                              );
                            },
                            child: const Text('Enquire Now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
