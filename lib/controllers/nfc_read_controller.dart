import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/services/database.dart';
import 'package:winetopia/services/auth.dart';

/// Provides methods for starting and managing NFC reading sessions.
class NfcReadController {
  final AuthService auth;

  NfcReadController(this.auth);

  /// Starts an NFC reading session and returns the resulting [NfcState].
  Future<NfcState> getNfcData(Function onError, Function onDiscovered) async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      final completer = Completer<NfcState>();

      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            onError(error);
            NfcManager.instance.stopSession();
            completer.complete(NfcState.error);
          },
          onDiscovered: (NfcTag tag) async {
            try {
              final nfcState = await _processTag(tag);
              onDiscovered(tag);
              completer.complete(nfcState);
            } catch (e) {
              onError(e);
              completer.complete(NfcState.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );

        return completer.future; // Return the future to be completed later
      } catch (e) {
        onError(e);
        return NfcState.error; // Error occurred during NFC session
      }
    } else {
      return NfcState.notAvailable; // NFC is not available
    }
  }

  /// Process the NFC tag to extract NDEF message and handle token cost information.
  Future<NfcState> _processTag(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          final payload = String.fromCharCodes(record.payload);
          final wineDocId = payload.trim(); // Payload is the wine docId

          // Validate the wine docId and handle the purchase
          return await _handleWinePurchase(wineDocId);
        }
      }
    }
    return NfcState.error; // Return error state if no valid NDEF data is found
  }

  Future<NfcState> _handleWinePurchase(String wineDocId) async {
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

        return NfcState.success; // Return success state
      } else {
        return NfcState.error; // Return error if wine is not found
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        return NfcState.insufficientTokens; // Return insufficient tokens state
      } else {
        throw Exception('Error processing wine purchase: $e');
      }
    }
  }
}
