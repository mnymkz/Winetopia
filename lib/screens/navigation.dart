import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:winetopia/screens/transaction_history/transaction_history.dart';
import 'package:winetopia/services/auth.dart';
import 'home/home.dart';
import 'package:winetopia/shared/verifyUrEmail.dart';

class NavigationScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _navigateCurvedBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(key: PageStorageKey('home')),
    const TransactionHistoryScreen(key: PageStorageKey('history')),
    const Placeholder(
        key: PageStorageKey(
            'placeholder')), // Replace with actual widget when ready
  ];

  @override
  Widget build(BuildContext context) {
    return _auth.checkVerifyEmail()
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'Winetopia',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple.shade400,
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text('Sign Out',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            backgroundColor: Colors.white,
            bottomNavigationBar: CurvedNavigationBar(
              index: _selectedIndex,
              backgroundColor: const Color(0xFFF6F6F6),
              color: Colors.deepPurple.shade400,
              animationDuration: const Duration(milliseconds: 200),
              onTap: _navigateCurvedBar,
              items: const [
                Icon(Icons.home, color: Colors.white),
                Icon(Icons.history, color: Colors.white),
                Icon(Icons.calendar_month, color: Colors.white),
              ],
            ),
          )
        : const VerifyEmail();
  }
}
