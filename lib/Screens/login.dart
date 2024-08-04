// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _role;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _role = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Name"),
        backgroundColor: Colors.blue, // Add a background color for the app bar
      ),
      body: Stack(children: [
        Image.asset(
          "assets/Images/seaBG.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Colors.white,
                      filled: true),
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fillColor: Colors.white,
                      filled: true),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        Map<String, dynamic> data = {
                          "username": _email.text,
                          "password": _password.text
                        };
                        print(data);
                        // final response = await http.post(
                        //   Uri.parse(
                        //       'https://f951-103-206-210-39.ngrok-free.app/user/register'),
                        //   headers: <String, String>{
                        //     'Content-Type': 'application/json; charset=UTF-8',
                        //   },
                        //   body: jsonEncode(data),
                        // );
                        // if (response.statusCode == 200) {
                        //   print("response: ");
                        //   print(jsonDecode(response.body));
                        // } else {
                        //   throw Exception('Failed to post data');
                        // }
                      } on Exception catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 16.0),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
