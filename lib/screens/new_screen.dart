import 'package:flutter/material.dart';

//test screen
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
