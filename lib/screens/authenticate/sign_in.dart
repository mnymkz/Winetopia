import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService(); //get an instance of the AuthService class (auth.dart)
  
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
        title: Text('Sign in', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          TextButton.icon(
            label: Text('Register', style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.person, color: Colors.white,),
            onPressed: (){
              //widget keyword refer to the widget itself which is Register
              widget.toggleView();
            }, 
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textImportDecoration.copyWith(hintText: 'Email'),
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
                validator:(val) => val!.isEmpty ? 'Enter a password' : null,
                obscureText: true, //hiding the text (for password)
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.black
                    ),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            error = 'Yeah, nah. That’s not a valid email or password.';
                          });
                        }
                      }
                    }, 
                    child: Text(
                      'Sign in',
                      //style: TextStyle(color: Colors.white)
                    ),
                  ),

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
              SizedBox(height: 20.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}