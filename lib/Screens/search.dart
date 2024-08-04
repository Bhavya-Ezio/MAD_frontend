// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _fetchData(String query) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://3040-103-206-210-39.ngrok-free.app/book/search/$query'));
      print("response: ");
      print(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data");
        print(data);
        setState(() {
          _searchResults = data['results']; // Replace with your data structure
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Search')),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 36, 157, 255)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _fetchData(value);
                },
                decoration: const InputDecoration(hintText: 'Search'),
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : _error.isNotEmpty
                    ? Text(_error)
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            // Replace with your data display logic
                            return ListTile(
                              title: Text(_searchResults[index]
                                  ['title']), // Replace with your data field
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
