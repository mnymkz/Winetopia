import 'package:flutter/material.dart';

//nfc reader screen returns app scaffold for the NFC reader
class NfcReaderScreen extends StatelessWidget {
  @override
  //placeholder view
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('NFC manager test screen'),
      ),
    );
  }
}
