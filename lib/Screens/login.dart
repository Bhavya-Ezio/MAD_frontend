import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isPasswordVisible = false; // Track password visibility

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


Future<void> _login() async {
  if (_email.text.isEmpty || _password.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields.')),
    );
    return; // Exit if fields are empty
  }

  final Map<String, dynamic> data = {
    "email": _email.text,
    "password": _password.text,
  };

  try {
    final response = await http.post(
      Uri.parse('https://mad-backend-x7p2.onrender.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print("Login response: ${response.body}"); // Print the response for debugging

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['userDetails'] != null) { // Check if userDetails is not null
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', responseData['token']);

        // Check role and navigate accordingly
        if (!mounted) return; // Check if the widget is still mounted
        if (responseData['userDetails']['role'] == 'Manager') {
          Navigator.of(context).pushReplacementNamed('/manager/home');
        } else if (responseData['userDetails']['role'] == 'User') {
          Navigator.of(context).pushReplacementNamed('/player/home');
        }
      } else {
        print("userDetails is null");
      }
    } else {
      final errorData = jsonDecode(response.body);
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${errorData['message'] ?? 'Unknown error'}'),
        ),
      );
      print("Login error: ${errorData['message']}");
    }
  } catch (e) {
    if (!mounted) return; // Check if the widget is still mounted
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred. Please try again.')),
    );
    print("Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Sports Hub",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/Images/logo.png",
                            height: 150,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _password,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              textStyle: const TextStyle(fontSize: 16.0),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                            child: const Text(
                              "Don't have an account? Sign up",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
