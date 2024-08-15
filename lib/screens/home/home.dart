import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/wine_sample.dart';
import 'package:winetopia/screens/home/nfc_read_button.dart';
import 'package:winetopia/controllers/nfc_read_controller.dart';
import 'package:winetopia/screens/home/wine_info_widget.dart';
import 'package:winetopia/services/auth.dart';
import '../profile.dart';

/// HomeScreen widget serves as the main screen of the app where users
/// can pay for wine samples.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  WineSample? _wineSample;

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
        child: Consumer<NfcState>(
          builder: (context, nfcState, child) {
            return ListView(
              shrinkWrap: true,
              children: [
                // Primary feedback message
                Center(
                  child: Text(
                    nfcState.primaryMessage,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // NFC Read Button
                GestureDetector(
                  onTap: () => _nfcButtonPressed(context),
                  child: NfcReadButton(nfcState: nfcState),
                ),
                const SizedBox(height: 20),

                // Secondary feedback message only shows if it is not empty
                if (nfcState.secondaryMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      nfcState.secondaryMessage,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Wine Info Widget - shows information about the recently purchased wine
                if (_wineSample != null) WineInfoWidget(wine: _wineSample),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewScreen()),
                      );
                    },
                    child: const Text('My Profile'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Initiates the NFC reading process and updates the NFC state based on the result
  void _nfcButtonPressed(BuildContext context) async {
    final nfcStateStream = Provider.of<NfcStateStream>(context, listen: false);
    nfcStateStream.updateState(NfcState.scanning);

    final nfcReadController = NfcReadController(
      auth: _auth,
      nfcStateStream: nfcStateStream,
      onWineSamplePurchased: (wineSample) {
        setState(() {
          _wineSample = wineSample;
        });
      },
    );

    // Start the NFC reading process
    await nfcReadController.getNfcData();
  }
}
