import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myproject/screens/addPresentation.dart';
import 'package:myproject/screens/library_list.dart';
import 'package:myproject/screens/loginPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:myproject/screens/tableView.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Future.delayed(
  //   const Duration(seconds: 3),
  // );
  FlutterNativeSplash.remove();
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

