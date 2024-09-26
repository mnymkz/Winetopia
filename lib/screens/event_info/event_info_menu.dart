// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:winetopia/screens/event_info/event_map.dart';
import 'package:winetopia/screens/event_info/exhibitors_list.dart';
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
      const ExhibitorList(), // Exhibitor List screen
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
        backgroundColor: const Color(0xFFFEFBFE),
        extendBody: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpeedDial(
              spacing: 20.0,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xFF292663),
              childMargin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.map,
                    color: Colors.white, // Set icon color to white
                  ),
                  backgroundColor: Color(0xE6761973),
                  label: "Event Map",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(0), // Navigate to Map
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.schedule,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xE6761973),
                  label: "Event Schedule",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(1), // Navigate to Schedule
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.people_alt,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xE6761973),
                  label: "Exhibitors",
                  labelStyle: TextStyle(fontSize: 18),
                  onTap: () => navigateToPage(2), // Navigate to Exhibitors
                )
              ]),
        ));
  }
}
