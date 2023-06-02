import 'dart:io';

import 'package:flutter/material.dart';
import 'package:first_app/login_register/login.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}
