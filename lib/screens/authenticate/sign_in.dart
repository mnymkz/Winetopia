import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService(); //get an instance of the AuthService class (auth.dart)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: Text('Sign in anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon(); //using dynamic type because it could be user of firebase type or null (see auth.dart)
            if(result == null)
            {
              print('error signning in');
            }
            else
            {
              print('signed in successfully');
              print(result.toString());
            }
          },
        ),
      ),
    );
  }
}