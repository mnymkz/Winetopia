import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/shared/constants.dart';
import 'package:winetopia/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.purple.shade50,
            appBar: AppBar(
              backgroundColor: const Color(0xFF292663),
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  label: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //widget keyword refer to the widget itself which is Register
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    children: <Widget>[
                      const SizedBox(
                        height: 40.0,
                      ),
                      Image.asset(
                        'assets/img/winetopia_logo.png',
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        decoration:
                            textImportDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
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
                        decoration:
                            textImportDecoration.copyWith(hintText: 'Password'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a password' : null,
                        obscureText: true, //hiding the text (for password)
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
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
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Yeah, nah. That’s not a valid email or password.';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: const Text('SIGN IN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          /* 
                          //for sign in as a guest, might remove this button latter on
                          ElevatedButton(
                            child: Text('Sign in as guest'),
                            onPressed: () async {
                              dynamic result = await _auth
                                  .signInAnon(); //using dynamic type because it could be user of firebase type or null (see auth.dart)
                              if (result == null) {
                                print('error signning in');
                              } else {
                                print('signed in successfully');
                                print('user id: ' + result.uid);
                              }
                            },
                          ), */
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
