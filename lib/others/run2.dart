import 'dart:io';
import 'package:first_app/others/ip_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
  if (exitCode != 0) {
    print("Termiinated");
  }
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: IP());
  }
}
