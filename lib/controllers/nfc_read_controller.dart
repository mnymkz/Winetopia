import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/ndef_record_info.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/wine_sample.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/services/auth.dart';

/// Controller class for NFC reading sessions
class NfcReadController {
  final AuthService auth;
  final NfcStateStream nfcStateStream;
  final Function(WineSample?) onWineSamplePurchased;

  NfcReadController({
    required this.auth,
    required this.nfcStateStream,
    required this.onWineSamplePurchased,
  });

  /// Starts an NFC reading session and modifies the [NfcState] accordingly.
  Future<void> getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            nfcStateStream
                .updateState(NfcState.error); // Change UI to error state
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              final wineSample = await _processTag(tag);
              onWineSamplePurchased(wineSample);
            } catch (e) {
              nfcStateStream
                  .updateState(NfcState.error); // Change UI to error state
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        nfcStateStream.updateState(NfcState.error); // Change UI to error state
      }
    } else {
      nfcStateStream.updateState(
          NfcState.notAvailable); // Change UI to NFC unavailable state
    }
  }

  /// Process the NFC tag to extract NDEF message.
  Future<WineSample?> _processTag(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          // Get wine doc id from record text
          final wineDocId = NdefRecordInfo.fromNdef(record).title;

          // Validate the wine docId and handle the purchase.
          final wineSample = await _handleWinePurchase(wineDocId);
          return wineSample;
        }
      }
    }

    nfcStateStream.updateState(NfcState.error); // Change UI to error state
    return null; // Return error state if no valid NDEF data is found
  }

  Future<WineSample?> _handleWinePurchase(String wineDocId) async {
    try {
      auth.setUserId(); // Set the user ID
      dynamic uid = auth.userID; // Get the user ID

      final wineSample = await DataBaseService(uid: uid).getWineInfo(wineDocId);

      if (wineSample != null) {
        // Deduct tokens from attendee account, add to exhibitor account, and add wine to attendee purchases list
        await DataBaseService(uid: uid).purchaseWine(wineSample.docId);
        nfcStateStream
            .updateState(NfcState.success); // Change UI to success state
        return wineSample; // Return success state
      } else {
        nfcStateStream.updateState(NfcState.error); // Change UI to error state
        return null; // Return error if wine is not found
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        nfcStateStream.updateState(NfcState
            .insufficientTokens); // Change UI to insufficient tokens state
        return null;
      } else {
        nfcStateStream.updateState(NfcState.error); // Change UI to error state
        // Error processing wine purchase
        return null;
      }
    }
  }
}
