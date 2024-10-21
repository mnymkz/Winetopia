import 'package:flutter/material.dart';
import 'package:winetopia/screens/authenticate/register.dart';
import 'package:winetopia/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //set showSingIn = true because the app need to show the Sign in page first
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      //reverse the value of showSignIn. Eg: if showSignIn = true then change it to false.
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
