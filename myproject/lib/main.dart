import 'package:flutter/material.dart';
// import 'package:myproject/screens/loginPage.dart';
import 'package:myproject/screens/tableView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "My Title",
    home: Scaffold(
      body: TableExampleApp(),
    ),
  );
  }
}

