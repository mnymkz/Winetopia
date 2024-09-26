// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:winetopia/screens/event_info/event_info_menu.dart';
import 'package:winetopia/screens/transaction_history/transaction_history.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/shared/nfc_state.dart';
import 'home/home.dart';
import 'profile.dart';
import 'package:winetopia/shared/verifyUrEmail.dart';

class NavigationScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<NavigationScreen> createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;
  late List<Widget> _screens;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Initialize screens and pass in the navKey
    _screens = [
      HomeScreen(
          key: PageStorageKey('home'),
          navKey: widget.key as GlobalKey<NavigationScreenState>?),
      const TransactionHistoryScreen(key: PageStorageKey('history')),
      const EventInfoMenu(), // Event Information,
    ];
  }

  void navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Provider.of<NfcState>(context, listen: false).resetState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _auth.checkVerifyEmail()
        ? Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/img/winetopia_logo.png', height: 55),
              backgroundColor: Color(0xFF292663),
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ProfileScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0,
                              0.0); // Start from the right (1.0 means off-screen right)
                          const end = Offset
                              .zero; // End at the center (normal position)
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                            milliseconds: 300), // Customize duration if needed
                      ),
                    );
                  },
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            backgroundColor: Color(0xFFF6F6F6),
            extendBody: false,
            bottomNavigationBar: CurvedNavigationBar(
              height: 71,
              index: _selectedIndex,
              backgroundColor: Color(0xFFF6F6F6),
              color: Color(0xFF292663),
              animationDuration: const Duration(milliseconds: 200),
              onTap: navigateToPage,
              items: const [
                Icon(Icons.home, color: Colors.white),
                Icon(Icons.history, color: Colors.white),
                Icon(Icons.calendar_month, color: Colors.white),
              ],
            ),
          )
        : VerifyEmail();
  }
}
