import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String fname = '';
  String lname = '';
  String phone = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.purple.shade50,
            appBar: AppBar(
                title: Image.asset('assets/img/winetopia_logo.png', height: 55),
                backgroundColor: Color(0xFF292663),
                elevation: 0.0,
                actions: <Widget>[
                  TextButton.icon(
                    label: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      //widget keyword refer to the widget itself which is Register
                      widget.toggleView();
                    },
                  ),
                ]),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textImportDecoration.copyWith(
                            hintText:
                                'Email'), //details in shared/constants.dart
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter an Email' : null,
                        //every time the text field in the form have a change, this function is triggered
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textImportDecoration.copyWith(
                            hintText: 'First name'),
                        validator: (val) => val!.isEmpty
                            ? 'Please enter your First Name'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            fname = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textImportDecoration.copyWith(
                            hintText: 'Last name'),
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter your Last Name' : null,
                        onChanged: (val) {
                          setState(() {
                            lname = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textImportDecoration.copyWith(
                            hintText: 'Phone number'),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a Phone number' : null,
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textImportDecoration.copyWith(hintText: 'Password'),
                        obscureText: true, //hiding the text (for password)
                        validator: (val) => val!.length < 6
                            ? 'Your Password needs to be atleast 6 characters'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textImportDecoration.copyWith(
                            hintText: 'Confirm Password'),
                        obscureText: true, //hiding the text (for password)
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (val != password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF761973),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.resigterWithEmailAndPassword(
                                    email, password, fname, lname, phone);
                            if (result == null) {
                              //handling error from firebase response
                              //for more error type, plz visit: https://firebase.google.com/docs/auth/admin/errors
                              setState(() {
                                if (_auth.firebaseErrorCode ==
                                    'invalid-email') {
                                  error = 'Invalid email';
                                } else if (_auth.firebaseErrorCode ==
                                    'email-already-in-use') {
                                  error = 'This email is already in use';
                                } else {
                                  error =
                                      'Sign up fail! Please try again later!';
                                }
                                loading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
