// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:winetopia/screens/event_info/event_map.dart';
import 'package:winetopia/screens/event_info/schedule.dart';

class EventInfoMenu extends StatefulWidget {
  final int initialIndex;
  const EventInfoMenu({super.key, this.initialIndex = 0});

  @override
  State<EventInfoMenu> createState() => EventInfoMenuState();
}

class EventInfoMenuState extends State<EventInfoMenu> {
  late int _selectedIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Initialize screens
    _screens = [
      const EventMap(), // Event Map screen
      const Schedule(), // Event Schedule screen
      Center(child: Text('Exhibitors')), // Placeholder for Exhibitors Screen
    ];
  }

  void navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        backgroundColor: Color(0xFFF6F6F6),
        extendBody: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpeedDial(
              spacing: 5.0,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xFF292663),
              children: [
                SpeedDialChild(
                  child: Icon(Icons.map),
                  backgroundColor: Color(0xE6761973).withOpacity(0.7),
                  label: "Event Map",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(0), // Navigate to Map
                ),
                SpeedDialChild(
                  child: Icon(Icons.schedule),
                  backgroundColor: Color(0xE6761973).withOpacity(0.7),
                  label: "Event Schedule",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(1), // Navigate to Schedule
                ),
                SpeedDialChild(
                  child: Icon(Icons.people_alt),
                  backgroundColor: Color(0xE6761973).withOpacity(0.7),
                  label: "Exhibitors",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(2), // Navigate to Exhibitors
                )
              ]),
        ));
  }
}
