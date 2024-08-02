import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';

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

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  backgroundColor: Colors.black
                ),
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    dynamic result = await _auth.resigterWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = 'Please supply a valid email!';
                      });
                    }
                  }
                }, 
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white)
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