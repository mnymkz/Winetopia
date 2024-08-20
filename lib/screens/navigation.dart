// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

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
    return Scaffold(
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
    );
  }
}