import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/ndef_record_info.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/services/database.dart';

/// A widget that displays NFC read results using a [FutureBuilder].
///
/// This widget would be replaced with the resulting confirmation message or
/// receipt of payment.
class NfcReadResultWidget extends StatelessWidget {
  /// A future that resolves to the scanned NFC tag.
  final Future<NfcTag?> scannedTag;

  /// The current NFC state.
  final NfcState nfcState;

  /// linking to firebase database
  final DataBaseService dataBaseService;

  /// Creates an [NfcReadResultWidget] with the provided [scannedTag] and [nfcState].
  const NfcReadResultWidget({
    super.key,
    required this.scannedTag,
    required this.nfcState,
    required this.dataBaseService,
  });

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
        //loop through NFC tag records
        for (var i = 0; i < cachedMessage.records.length; i++) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);

          //TODO - define how information is stored on the tag (for now, the first record will have tCost)
          //get token cost
          final payload = String.fromCharCodes(record.payload);
          final parts = payload.split(':');
          if (parts.length == 2) {
            final tokenCostString = parts[1];
            try {
              //parse int from data
              final tokenCost = int.parse(tokenCostString);
              dataBaseService.deductTokens(tokenCost);
              print('Transaction successful');
              //TODO - handle successful transaction (lead to a new screen)
            } catch (e) {
              print('Invalid token format: $e');
              //TODO - handle transaction error (display to user)
            }
          }

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
