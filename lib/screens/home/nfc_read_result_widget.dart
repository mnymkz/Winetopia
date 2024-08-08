import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/ndef_record_info.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/services/auth.dart';
import 'package:winetopia/services/database.dart';

/// A widget that displays NFC read results using a [FutureBuilder].
///
/// This widget would be replaced with the resulting confirmation message or
/// receipt of payment.
class NfcReadResultWidget extends StatelessWidget {
  final Future<NfcTag?> scannedTag; // the scanned tag
  final NfcState nfcState; // the nfc state
  final AuthService auth; // the auth service

  /// Creates an [NfcReadResultWidget] with the provided [scannedTag] and [nfcState].
  const NfcReadResultWidget(
      {super.key,
      required this.scannedTag,
      required this.nfcState,
      required this.auth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: scannedTag,
        builder: (BuildContext context, AsyncSnapshot<NfcTag?> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: readNdef(snapshot.data!),
              ),
            );
          } else {
            if (nfcState == NfcState.error ||
                nfcState == NfcState.notAvailable) {
              return const Center(
                child: Text('No data'),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  /// Converts an `NfcTag` into a list of widgets displaying the NDEF data.
  ///
  /// Returns a list of widgets representing the NDEF records contained
  /// in the provided `tag`. If no NDEF data is found, returns a widget
  /// indicating this.
  List<Widget> readNdef(NfcTag tag) {
    List<Widget> ndefWidgets = [];

    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        // Loop through NFC tag records
        for (var i = 0; i < cachedMessage.records.length; i++) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);

          //Display Ntag information
          ndefWidgets.add(
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.purple,
              child: ListTile(
                title: const Text('This wine sample costs:',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  info.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          );
        }
      }
      //return widget containing information
      return ndefWidgets;
    } else {
      return [const Text('No NDEF data found')];
    }
  }
}
