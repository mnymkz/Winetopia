import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';


class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});
 
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
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
                      'An email has been sent to you with instruction to verify your email address.\nYou have to verify your email before using the app!'),
                  SizedBox(
                    height: 20,
                  ),
                  
                  Text(
                      'Contact Winetopia-app team at <our info> for further assistance')
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK!'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  await auth.signOut();
                },
              ),
            ],
          );
        },
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Ur Email!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0.0,
      ),
      
    );
    
  }
}