//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          logout = true; //stop the stream Builder
                          await _auth.signOut();
                        },
                        child: const Text('Sign out',
                            style: TextStyle(color: Colors.white)),
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
                    child: const Text('Continue',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    void showToast(String message, Color backgroundColor) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    final user = Provider.of<WinetopiaUser?>(context);

    return logout
        ? const HomeScreen()
        : StreamBuilder<UserData>(
            stream: DataBaseService(uid: user!.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DataBaseService(uid: user.uid)
                    .updateEmail(_auth.getUserEmail());
                UserData? userData = snapshot.data;
                return loading
                    ? const Loading()
                    : Scaffold(
                        resizeToAvoidBottomInset: true,
                        backgroundColor: Colors.purple[50],
                        appBar: AppBar(
                          centerTitle: true,
                          title: const Text(
                            'Profile',
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
                        body: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 30.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const Text('Email',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 46,
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: textImportDecoration.copyWith(
                                          hintText: '${userData?.email}',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.normal)),
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text('First name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 46,
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: textImportDecoration.copyWith(
                                          hintText: '${userData?.fname}',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.normal)),
                                      onChanged: (val) {
                                        setState(() {
                                          fname = val;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text('Last name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 46,
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: textImportDecoration.copyWith(
                                          hintText: '${userData?.lname}',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.normal)),
                                      onChanged: (val) {
                                        setState(() {
                                          lname = val;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text('Phone',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 46,
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: textImportDecoration.copyWith(
                                          hintText: '${userData?.phone}',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.normal)),
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
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text('Update Password',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(
                                    height: 46,
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: textImportDecoration.copyWith(
                                          hintText: 'Enter new password',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.normal)),
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
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF761973),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
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
                                            //print('email: ' + email);
                                            //updating email for authentication
                                            dynamic resultEmailAuth =
                                                await _auth.updateEmail(email);
                                            //print(result_email_auth);
                                            //handling error from firebase auth is not working!
                                            if (resultEmailAuth == false) {
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
                                      child: const Text(
                                        'Update Details',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 80.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[400],
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 20.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          deleteAccountDialog();
                                        },
                                        child: const Text('Delete Account',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Text(
                                        error,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14.0),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF761973),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 20.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          logout =
                                              true; //stop the stream Builder
                                          await _auth.signOut();
                                        },
                                        child: const Text(
                                          'Sign Out',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              } else {
                return Scaffold(
                  backgroundColor: Colors.purple.shade50,
                  body: const Center(
                    child: Loading(),
                  ),
                );
              }
            });
  }
}
