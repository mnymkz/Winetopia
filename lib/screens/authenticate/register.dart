import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //get an instance of the AuthService class (auth.dart)
  final AuthService _auth = AuthService(); 

  //text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        elevation: 0.0,
        title: Text('Sign up', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                //every time the text field in the form have a change, this function is triggered
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true, //hiding the text (for password)
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),
                onPressed: () async{
                  print("email:" + email);
                  print("password: " + password);
                }, 
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white)
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}