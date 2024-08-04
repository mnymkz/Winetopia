import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';
import '../new_screen.dart';
import 'package:winetopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/screens/home/attendee.dart';

//test homescreen contains placeholder home screen
class HomeScreen extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DataBaseService(uid: '').attendees,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('Winetopia - Home', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.purple[800],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text(
                'sign out',
                style: TextStyle(color: Colors.white)
              ),
              onPressed: () async{
                await _auth.signOut();
              }, 
            ),
          ],
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the new screen when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewScreen()),
              );
            },
            child: Text('Go to New Screen'),
          ),
        ),
        //body: Attendee(),
      ),
    );
  }
}
