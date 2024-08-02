import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'home/home.dart'; // Import the home screen
import 'new_screen.dart'; // Import the new screen

//screen wrapper class contains the screens
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<WinetopiaUser?>(context);

    //show either home screen or authenticate screen
    if(user == null){
      return Authenticate();
    }
    else{
      return HomeScreen();
    }
    
  }
}
