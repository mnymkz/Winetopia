import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'package:winetopia/screens/authenticate/sign_in.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/shared/constants.dart';
import 'package:winetopia/shared/loading.dart';
import 'package:flutter/services.dart';

//test screen
class NewScreen extends StatefulWidget {
  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
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
  //placeholder view
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verify Your Email'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'An email has been sent to you with instruction to verify your new email address. If you change your mind, just ignore this email.'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Please sign in again after verify to show your new email!'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Contact Winetopia-app team at <our info> for further assistance')
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final user = Provider.of<WinetopiaUser?>(context);

    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          DataBaseService(uid: user!.uid).updateEmail(_auth.getUserEmail());
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return loading
                ? Loading()
                : Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.purple[50],
                    appBar: AppBar(
                      backgroundColor: Colors.purple[800],
                      elevation: 0.0,
                      title: Text(
                        'Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    body: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 70.0,
                                ),
                                Text(
                                  'Token Balance: ${userData?.tokenAmount}',
                                  style: TextStyle(fontSize: 20),
                                ),

                                // SizedBox(width: 30,),
                                // IconButton(
                                //   onPressed: () async{
                                //     print(await _auth.getUserEmail());
                                //     dynamic result_email = await DataBaseService(uid: user!.uid).updateEmail(await _auth.getUserEmail());
                                //   },
                                //   icon: Icon(Icons.replay_rounded)
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textImportDecoration.copyWith(
                                  hintText: 'Email: ${userData?.email}'),
                              //validator:(val) => val!.isEmpty ? 'Please enter an Email' : null,
                              //every time the text field in the form have a change, this function is triggered
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textImportDecoration.copyWith(
                                  hintText: 'First name: ${userData?.fname}'),
                              //validator:(val) => val!.isEmpty ? 'Please enter your First Name' : null,
                              onChanged: (val) {
                                setState(() {
                                  fname = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textImportDecoration.copyWith(
                                  hintText: 'Last name: ${userData?.lname}'),
                              //validator:(val) => val!.isEmpty ? 'Please enter your Last Name' : null,
                              onChanged: (val) {
                                setState(() {
                                  lname = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textImportDecoration.copyWith(
                                  hintText: 'Phone: ${userData?.phone}'),
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              //validator:(val) => val!.isEmpty ? 'Please enter a Phone number' : null,
                              onChanged: (val) {
                                setState(() {
                                  phone = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textImportDecoration.copyWith(
                                  hintText: 'New Password'),
                              obscureText:
                                  true, //hiding the text (for password)
                              validator: (val) => (val!.length < 6 &&
                                      val.isNotEmpty)
                                  ? 'Your Password needs to be atleast 6 characters'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  //backgroundColor: Colors.black
                                  ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  if (password != '') {
                                    dynamic result_password =
                                        await _auth.updatePassword(password);
                                    if (result_password == null) {
                                      setState(() {
                                        if (_auth.firebaseErrorCode ==
                                            'requires-recent-login') {
                                          error =
                                              'Changging password requires recent authentication. Please log in again!';
                                        }
                                      });
                                    }
                                    password = '';
                                  }

                                  if (email != '') {
                                    print('email: ' + email);
                                    //updating email for authentication
                                    dynamic result_email_auth =
                                        await _auth.updateEmail(email);
                                    print(result_email_auth);
                                    //handling error from firebase auth is not working!
                                    if (result_email_auth == false) {
                                      //handling error from firebase response
                                      //for more error type, plz visit: https://firebase.google.com/docs/auth/admin/errors
                                      setState(() {
                                        if (_auth.firebaseErrorCode ==
                                            'user-token-expired') {
                                          error =
                                              'Changging Email requires recent authentication. Please log in again!';
                                        } else if (_auth.firebaseErrorCode ==
                                            'requires-recent-login') {
                                          error =
                                              'Changging Email requires recent authentication. Please log in again!';
                                        } else if (_auth.firebaseErrorCode ==
                                            'unknown') {
                                          error = 'Invalid email';
                                        } else {
                                          error =
                                              'Update fail! Please try again latter!';
                                        }
                                      });
                                    } else {
                                      _showMyDialog();
                                    }

                                    email = '';
                                  }

                                  if (fname != '') {
                                    dynamic result =
                                        await DataBaseService(uid: user!.uid)
                                            .updateFirstName(fname);
                                    fname = '';
                                  }

                                  if (lname != '') {
                                    dynamic result =
                                        await DataBaseService(uid: user!.uid)
                                            .updateLastName(lname);
                                    lname = '';
                                  }

                                  if (phone != '') {
                                    dynamic result =
                                        await DataBaseService(uid: user!.uid)
                                            .updatePhone(phone);
                                    phone = '';
                                  }

                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              child: Text(
                                'Update!',
                                //style: TextStyle(color: Colors.white)
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Text('Something happend with firebase!'),
              ),
            );
          }
        });
  }
}
