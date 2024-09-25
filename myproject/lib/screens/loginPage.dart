import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/screens/library_list.dart';
// Required for BackdropFilter


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String _email = '';
  String _password = '';
  bool _hasError = false; // Variable to track if the field has an error

    Future<void> checkPasswordIncorrect(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.gpp_maybe_rounded,
                  color: _hasError ? Colors.red : Colors.blueGrey,
                  size: 60.0,
                ),
                const Text('Username or Password incorrect'),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }


   Future<void> _loginUser(String email, String password) async {
    try {
      // API URL
      var url = Uri.parse('http://192.168.101.199:3001/getUser');
      
      // Make HTTP POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Sending JSON data
        },
        body: jsonEncode({
          'userInput': email, // Email parameter
          'password': password, // Password parameter
        }),
      );
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.length == 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text("Login Successful")),
              );
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (ctx) => const LibraryList())
              );
        } else {
          checkPasswordIncorrect(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server Error")),
        );
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/systory_background.png'), // Replace with your image path
            fit: BoxFit.cover, // This will ensure the image covers the whole screen
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 230.0),
            child: SingleChildScrollView(
              child: ClipRRect(
                // ClipRRect is necessary to apply the blur within the card's borders
                borderRadius: BorderRadius.circular(15), // Same radius as the card
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset(
                        //   'assets/images/systory_logo.png', // Replace with your image path
                        //   height: 180,
                        //   width: 180,
                        // ),
                        const SizedBox(height: 20),
                        Text(
                          "Login",
                          style: GoogleFonts.notoSansLao(
                            textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email Field
                        TextFormField(
                          style: const TextStyle(color: Colors.blueGrey),
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle( // Style the label text here
                              color: _hasError ? Colors.red : Colors.blueGrey, // Example: setting the label color to white
                            ),
                            prefixIcon: Icon(Icons.person, color: _hasError ? Colors.red : Colors.blueGrey,),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey, // Custom border color for the enabled state
                              ),
                            ),
                                   // Border when the field is focused
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent, // Custom border color when focused
                              ),
                            ),
                                             // Border when there's an error
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, // Custom border color for error state
                              ),
                            ),  
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value) {
                            setState(() {
                              _hasError = value == null || value.isEmpty; // Set the error state
                            });
                            if (_hasError) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        TextFormField(
                          style: const TextStyle(color: Colors.blueGrey),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle( // Style the label text here
                              color: _hasError ? Colors.red : Colors.blueGrey, // Example: setting the label color to white
                            ),
                            prefixIcon: Icon(Icons.lock, color: _hasError ? Colors.red : Colors.blueGrey,),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey, // Custom border color for the enabled state
                              ),
                            ),
                
                                                        // Border when the field is focused
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent, // Custom border color when focused
                                width: 2.0, // Thickness of the border when focused
                              ),
                            ),
                                             // Border when there's an error
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, // Custom border color for error state
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                    color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _loginUser(_email, _password); // Call login function
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 160),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}