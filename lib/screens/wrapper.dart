import 'package:flutter/material.dart';
import 'home_test.dart'; // Import the home screen
import 'new_screen.dart'; // Import the new screen

//screen wrapper class contains the screens
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return homescreen by default
    return HomeScreen();
  }
}
