import 'package:flutter/material.dart';

//nfc reader screen returns app scaffold for the NFC reader
class NewScreen extends StatelessWidget {
  @override
  //placeholder view
  Widget build(BuildContext context) {
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
