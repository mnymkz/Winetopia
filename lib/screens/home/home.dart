import 'package:flutter/material.dart';
import 'package:winetopia/screens/home/nfc_read_button.dart';
import 'package:winetopia/services/auth.dart';
import '../new_screen.dart';

/// HomeScreen widget serves as the main screen of the app where users
/// can pay for wine samples.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  bool _isReading = false;

  /// Toggles the NFC reading state.
  void nfcButtonPressed() {
    setState(() {
      _isReading = !_isReading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text(
          'Winetopia - Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple[800],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label:
                const Text('sign out', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Display text based on NFC reading state
            Center(
              child: Text(
                  _isReading ? 'Scanning...' : 'Tap to pay for a wine sample'),
            ),
            const SizedBox(height: 20),

            // NFC Read Button
            GestureDetector(
                onTap: nfcButtonPressed,
                child: NfcReadButton(isReading: _isReading)),
            const SizedBox(height: 20),

            // Button to navigate to a new screen
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewScreen()),
                  );
                },
                child: const Text('Go to New Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
