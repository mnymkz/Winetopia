import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService(); //get an instance of the AuthService class (auth.dart)

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
        title: Text('Sign in', style: TextStyle(color: Colors.white),),
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
                  print("email: " + email);
                  print("password: " + password);
                }, 
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white)
                ),
              ),
              
              SizedBox(height: 20.0,),
              //for sign in as a guess, might remove this button latter on
              ElevatedButton(
                child: Text('Sign in as guess'),
                onPressed: () async {
                  dynamic result = await _auth.signInAnon(); //using dynamic type because it could be user of firebase type or null (see auth.dart)
                  if(result == null)
                  {
                    print('error signning in');
                  }
                  else
                  {
                    print('signed in successfully');
                    print('user id: ' + result.uid);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}