// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'home/home.dart';
import 'profile.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final AuthService _auth = AuthService();

  void _navigateCurvedBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    HomeScreen(), // navigates to home screen (nfc scanning)
    HomeScreen(), // change route to history
    HomeScreen(), // change route to event info
    NewScreen(), // navigates to profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Winetopia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the profile screen
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Start from the right (1.0 means off-screen right)
                    const end = Offset.zero; // End at the center (normal position)
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300), // Customize duration if needed
                ),
              );
            },
          ),
        ],
      ),

      body: _screens[_selectedIndex],

      //backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purple.shade50,
        color: Colors.deepPurple.shade400,
        animationDuration: Duration(milliseconds: 200),
        onTap: _navigateCurvedBar,
        items: [
          Icon(
            Icons.home,
            color: Colors.white
          ),
          Icon(
            Icons.history,
            color: Colors.white
          ),
          Icon(
            Icons.calendar_month,
            color: Colors.white
          ),
        ]
      ),
    );
  }
}