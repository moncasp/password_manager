import 'package:flutter/material.dart';
import 'package:password_manager/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "moncasp",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ) ;
  }
}
