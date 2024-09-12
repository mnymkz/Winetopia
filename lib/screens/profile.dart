//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'package:winetopia/screens/authenticate/sign_in.dart';
import 'package:winetopia/screens/home/home.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/services/database_service.dart';
import 'package:winetopia/shared/constants.dart';
import 'package:winetopia/shared/loading.dart';
import 'package:flutter/services.dart';

//test screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //get an instance of the AuthService class (auth.dart)
  final AuthService _auth = AuthService();

  //this variable will keep tract the state of the form
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool logout = false;

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
    final Function toggleView;
    Future<void> changeEmailDialog() async {
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
                  Navigator.of(context).pop();
                  logout = true;
                  _auth.signOut();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> errorDialog() async {
      Future.microtask(
        () {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Require recent login'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Delete account is a sensitive operation which require recent login. \nPlease sign in again!'),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Sign out', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          logout = true; //stop the stream Builder
                          await _auth.signOut();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    }

    Future<void> deleteAccountDialog() async {
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
                      'Your profile will be deleted permanently. This action is irreversible!'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Continue?'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Continue!',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      logout = true; //stop the stream Builder
                      await _auth.deleteAccount();
                      if (_auth.firebaseErrorCode == 'requires-recent-login') {
                        errorDialog();
                      }
                      //can use else here since _auth.delete() only have one exception.
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    final user = Provider.of<WinetopiaUser?>(context);

    return logout
        ? HomeScreen()
        : StreamBuilder<UserData>(
            stream: DataBaseService(uid: user!.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DataBaseService(uid: user.uid)
                    .updateEmail(_auth.getUserEmail());
                UserData? userData = snapshot.data;
                return loading
                    ? Loading()
                    : Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.purple[50],
                        appBar: AppBar(
                          title: const Text(
                            'Winetopia',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF292663),
                          elevation: 0.0,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        body: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 70.0,
                                    ),
                                    Text(
                                      'Gold Token Balance: ${userData?.goldTokens}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Silver Token Balance: ${userData?.silverTokens}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  decoration: textImportDecoration.copyWith(
                                      hintText: 'Email: ${userData?.email}'),
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
                                      hintText:
                                          'First name: ${userData?.fname}'),
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
                                      hintText:
                                          'Last name: ${userData?.lname}'),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
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
                                                await _auth
                                                    .updatePassword(password);
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
                                                } else if (_auth
                                                        .firebaseErrorCode ==
                                                    'requires-recent-login') {
                                                  error =
                                                      'Changging Email requires recent authentication. Please log in again!';
                                                } else if (_auth
                                                        .firebaseErrorCode ==
                                                    'unknown') {
                                                  error = 'Invalid email';
                                                } else {
                                                  error =
                                                      'Update fail! Please try again latter!';
                                                }
                                              });
                                            } else {
                                              changeEmailDialog();
                                            }

                                            email = '';
                                          }

                                          if (fname != '') {
                                            dynamic result =
                                                await DataBaseService(
                                                        uid: user!.uid)
                                                    .updateFirstName(fname);
                                            fname = '';
                                          }

                                          if (lname != '') {
                                            dynamic result =
                                                await DataBaseService(
                                                        uid: user!.uid)
                                                    .updateLastName(lname);
                                            lname = '';
                                          }

                                          if (phone != '') {
                                            dynamic result =
                                                await DataBaseService(
                                                        uid: user!.uid)
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        logout = true; //stop the stream Builder
                                        await _auth.signOut();
                                      },
                                      child: Text(
                                        'Sign Out',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400],
                                  ),
                                  onPressed: () async {
                                    deleteAccountDialog();
                                  },
                                  child: Text('Delete Profile!',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              } else {
                return Scaffold(
                  backgroundColor: Colors.purple.shade50,
                  body: Center(
                    child: Loading(),
                  ),
                );
              }
            });
  }
}
