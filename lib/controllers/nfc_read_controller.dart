import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/wine_sample.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/services/auth.dart';

/// Provides methods for starting and managing NFC reading sessions.
class NfcReadController {
  final AuthService auth;
  final NfcStateModel nfcState;
  final Function(WineSample?) onWineSamplePurchased;

  NfcReadController({
    required this.auth,
    required this.nfcState,
    required this.onWineSamplePurchased,
  });

  /// Starts an NFC reading session and returns the resulting [NfcState].
  Future<void> getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            nfcState.updateState(NfcState.error);
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              final wineSample = await _processTag(tag);
              onWineSamplePurchased(wineSample);
            } catch (e) {
              nfcState.updateState(NfcState.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        nfcState.updateState(NfcState.error);
      }
    } else {
      nfcState.updateState(NfcState.notAvailable);
    }
  }

  /// Process the NFC tag to extract NDEF message and handle token cost information.
  Future<WineSample?> _processTag(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          final payload = String.fromCharCodes(record.payload);
          final wineDocId = payload.trim(); // Payload is the wine docId

          // Validate the wine docId and handle the purchase
          final wineSample = await _handleWinePurchase(wineDocId);
          if (wineSample != null) {
            nfcState.updateState(NfcState.success);
          }
          return wineSample;
        }
      }
    }

    nfcState.updateState(NfcState.error);
    return null; // Return error state if no valid NDEF data is found
  }

  Future<WineSample?> _handleWinePurchase(String wineDocId) async {
    try {
      auth.setUserId(); // Set the user ID
      dynamic uid = auth.userID; // Get the user ID from the database file

      // Get the wine information from Firestore
      final wineSample = await DataBaseService(uid: uid).getWineInfo(wineDocId);

      if (wineSample != null) {
        // Deduct wine's tPrice from the user's token amount
        await DataBaseService(uid: uid).deductTokens(wineSample.tPrice);

        // Add the wine's docId to the attendee's purchased wines list
        await DataBaseService(uid: uid).addPurchasedWine(wineDocId);

        return wineSample; // Return success state
      } else {
        return null; // Return error if wine is not found
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        nfcState.updateState(
            NfcState.insufficientTokens); // Return insufficient tokens state
        return null;
      } else {
        // Error processing wine purchase
        return null;
      }
    }
  }
}
