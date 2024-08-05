import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/screens/home/nfc_read_button.dart';
import 'package:winetopia/screens/home/nfc_read_result_widget.dart';
import 'package:winetopia/controllers/nfc_read_controller.dart';
import 'package:winetopia/services/auth.dart';
import '../new_screen.dart';
import 'package:winetopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/screens/home/attendee.dart';

/// HomeScreen widget serves as the main screen of the app where users
/// can pay for wine samples.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  Future<NfcTag?> _scannedTag = Future.value(null);
  NfcState _nfcState = NfcState.idle;

  /// Initiates the NFC reading process and updates the NFC state based on the result.
  void nfcButtonPressed() async {
    setState(() {
      _nfcState = NfcState.scanning;
    });

    final NfcState result =
        await NfcReadController.getNfcData(_handleError, _handleDiscovered);
    setState(() {
      _nfcState = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
        value: DataBaseService(uid: '').attendees,
        initialData: null,
        child: Scaffold(
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
                label: Text('sign out', style: TextStyle(color: Colors.white)),
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
                  child: Text(_nfcState.feedbackMessage),
                ),
                const SizedBox(height: 20),

                // NFC Read Button
                GestureDetector(
                    onTap: nfcButtonPressed,
                    child: NfcReadButton(nfcState: _nfcState)),
                const SizedBox(height: 20),

                // NFC Read Result (to be deleted later)
                NfcReadResultWidget(
                  scannedTag: _scannedTag,
                  nfcState: _nfcState,
                ),

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
        ));
  }

  /// Handles errors during the NFC session and updates the state accordingly.
  void _handleError(dynamic error) {
    setState(() {
      _nfcState = NfcState.error;
      _scannedTag = Future.error(error);
    });
  }

  /// Handles NFC tag discovery and updates the state with the discovered tag.
  void _handleDiscovered(NfcTag tag) {
    setState(() {
      _nfcState = NfcState.success;
      _scannedTag = Future.value(tag);
    });
  }
}
