import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myproject/screens/library_list.dart';
import 'package:myproject/screens/loginPage.dart';

void main() async{
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name = "";
  String id = "";
  bool isLogin = false;

   @override
  void initState() {
    super.initState();
    checkLogin();
  }

  // Function to check login status
  Future<void> checkLogin() async {
    await initLocalStorage(); // Ensure storage is ready
    name = localStorage.getItem('userName') ?? "";
    id = localStorage.getItem('userId') ?? "";

    if (name.isNotEmpty && id.isNotEmpty) {
      setState(() {
        isLogin = true; // Update state to reflect login status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkLogin();
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "My Title",
    home: Scaffold(
      body: isLogin ?
      const LibraryList()
      :
      const LoginPage(),
    ),
  );
  }
}

