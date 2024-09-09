import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'navigation.dart';
//import 'home/home.dart'; // Import the home screen

//screen wrapper class contains the screens
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WinetopiaUser?>(context);
    print(user.toString());
    //show either home screen or authenticate screen
    if (user == null) {
      return Authenticate();
    } else {
      //return HomeScreen();
      return NavigationScreen();
    }
  }
}
