import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Language_tranlation.dart'; // Ensure this file exists and is correctly named

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 7, 94, 225),
        scaffoldBackgroundColor: const Color.fromARGB(255, 7, 94, 225),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = "";

  Future<void> login() async {
    const url =
        "http://10.97.22.12/flutter_backend/login.php"; // Ensure this URL is correct
    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
        // Navigate to LanguageTranlationPage on successful login
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LanguageTranlationPage()),
          );
        } else {
          setState(() {
            message = data['message'];
          });
        }
      } else {
        setState(() {
          message = "Error connecting to server.";
        });
        debugPrint("Response status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        message = "An error occurred: $e";
      });
      debugPrint("Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2b3c5a)),
                  child: const Text("Login"),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
