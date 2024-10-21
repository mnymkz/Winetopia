import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/screens/authenticate/authenticate.dart';
import 'navigation.dart';

//screen wrapper class contains the screens
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WinetopiaUser?>(context);
    // Show either home screen or authenticate screen
    if (user == null) {
      return const Authenticate();
    } else {
      final GlobalKey<NavigationScreenState> navKey =
          GlobalKey<NavigationScreenState>();
      return NavigationScreen(key: navKey);
    }
  }
}
