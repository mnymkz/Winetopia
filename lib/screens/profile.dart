import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/shared/constants.dart';
import 'package:winetopia/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';

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
  //String email = '';
  String password = '';
  String fname = '';
  String lname = '';
  String phone = '';
  String error = '';

  @override
  //placeholder view
  Widget build(BuildContext context) {
    
    final user = Provider.of<WinetopiaUser?>(context);

    return StreamBuilder<UserData>(
      stream: DataBaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData? userData = snapshot.data;
          return loading ? Loading() : Scaffold(
            resizeToAvoidBottomInset : false,
            backgroundColor: Colors.purple[50],
            appBar: AppBar(
              backgroundColor: Colors.purple[800],
              elevation: 0.0,
              title: Text('Profile', style: TextStyle(color: Colors.white),),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Text('Token Balance: ${userData?.tokenAmount}', style: TextStyle(fontSize: 20),),
                    SizedBox(height: 30.0,),
                    Text('Email: ${userData?.email}'),
                    // SizedBox(height: 20.0,),
                    // TextFormField(
                    //   decoration: textImportDecoration.copyWith(hintText: 'Email: ${userData?.email}'), 
                    //   validator:(val) => val!.isEmpty ? 'Please enter an Email' : null,
                    //   //every time the text field in the form have a change, this function is triggered
                    //   onChanged: (val){
                    //     setState(() {
                    //       email = val;
                    //     });
                    //   },
                    // ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textImportDecoration.copyWith(hintText: 'First name: ${userData?.fname}'),
                      //validator:(val) => val!.isEmpty ? 'Please enter your First Name' : null,
                      onChanged: (val){
                        setState(() {
                          fname = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textImportDecoration.copyWith(hintText: 'Last name: ${userData?.lname}'),
                      //validator:(val) => val!.isEmpty ? 'Please enter your Last Name' : null,
                      onChanged: (val){
                        setState(() {
                          lname = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textImportDecoration.copyWith(hintText: 'Phone: ${userData?.phone}'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      //validator:(val) => val!.isEmpty ? 'Please enter a Phone number' : null,
                      onChanged: (val){
                        setState(() {
                          phone = val;
                        });
                      },
                    ),
                    // Changing password feature will be develope in the future
                    // SizedBox(height: 20.0,),
                    // TextFormField(
                    //   decoration: textImportDecoration.copyWith(hintText: 'New Password'),
                    //   obscureText: true, //hiding the text (for password)
                    //   validator:(val) => val!.length < 6 ? 'Your Password needs to be atleast 6 characters' : null,
                    //   onChanged: (val){
                    //     setState(() {
                    //       password = val;
                    //     });
                    //   },
                    // ),
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
                          if(fname == '')
                          {
                            fname = userData!.fname;
                          }
                          if(lname == '')
                          {
                            lname = userData!.lname;
                          }
                          if(phone == '')
                          {
                            phone = userData!.phone;
                          }
                          dynamic result = await DataBaseService(uid: user!.uid).updateUserData(userData!.email, fname, lname, phone, userData!.tokenAmount);
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

                    SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              bool? confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth.deleteAccount();
                                if (result == null) {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Authenticate()),
                                  );// go to authenticate screen
                                } else {
                                  setState(() {
                                    loading = false;
                                    error = 'Failed to delete the account: $result';
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom( //add colours soon maybe hmm idk!!!
                            ),
                            child: Text('Delete Account'),
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
        }else{
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Center(
              child: Text('test screen'),
            ),
          );
        }
        
      }
    );
  }
}
