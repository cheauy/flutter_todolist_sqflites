import 'package:flutter/material.dart';
import 'package:todolists/screen/home_screen_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff005f6b),
          ),
        ),
        home: const Homesceen());
  }
}
