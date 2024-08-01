import 'package:flutter/material.dart';
import 'new_screen.dart';

//test homescreen contains placeholder home screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
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
    );
  }
}
