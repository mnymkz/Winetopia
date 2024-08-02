import 'package:flutter/material.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'home/home_test.dart'; // Import the home screen
import 'new_screen.dart'; // Import the new screen

//screen wrapper class contains the screens
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //show either home screen or authenticate screen
    return Authenticate();
  }
}
