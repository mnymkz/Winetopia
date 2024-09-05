// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/auth.dart';
import 'home/home.dart';
import 'package:winetopia/shared/verifyUrEmail.dart';

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
    HomeScreen(),
    HomeScreen(), // change route to history
    HomeScreen(), // change route to event info
  ];

  @override
  Widget build(BuildContext context) {
    return _auth.checkVerifyEmail() ? Scaffold(
      appBar: AppBar(
        title: const Text(
          'Winetopia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label:
                const Text('Sign Out', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),

      body: _screens[_selectedIndex],

      backgroundColor: Colors.white,
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
    ) : VerifyEmail();
  }
}