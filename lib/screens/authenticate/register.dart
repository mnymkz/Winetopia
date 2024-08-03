import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/shared/constants.dart';
import 'package:winetopia/shared/loading.dart';

class Register extends StatefulWidget {
  
  final Function toggleView;
  const Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //get an instance of the AuthService class (auth.dart)
  final AuthService _auth = AuthService(); 

  //this variable will keep tract the state of the form
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        elevation: 0.0,
        title: Text('Sign up', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          TextButton.icon(
            label: Text('Sign in', style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: (){
              //widget keyword refer to the widget itself which is Register
              widget.toggleView();
            }, 
          ),
        ]
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textImportDecoration.copyWith(hintText: 'Email'), //details in shared/constants.dart
                validator:(val) => val!.isEmpty ? 'Enter an email' : null,
                //every time the text field in the form have a change, this function is triggered
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textImportDecoration.copyWith(hintText: 'Password'),
                obscureText: true, //hiding the text (for password)
                validator:(val) => val!.length < 6 ? 'Password need to have more than 6 characters' : null,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.black
                ),
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.resigterWithEmailAndPassword(email, password);
                    if(result == null){
                      //handling error from firebase response
                      //for more error type, plz visit: https://firebase.google.com/docs/auth/admin/errors
                      setState(() {
                        if(_auth.firebaseErrorCode == 'invalid-email'){
                          error = 'Invalid email';
                        }
                        else if(_auth.firebaseErrorCode == 'email-already-in-use'){
                          error = 'This email is already in use';
                        }
                        else{
                          error = 'Sign up fail! Please try again latter!';
                        }
                        loading = false;
                      });
                    }
                  }
                }, 
                child: Text(
                  'Register',
                  //style: TextStyle(color: Colors.white)
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}