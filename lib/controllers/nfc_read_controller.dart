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
              final nfcState = await _handleTagDiscovered(tag);
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

  /// Handles the discovered NFC tag and performs the token deduction.
  Future<NfcState> _handleTagDiscovered(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        // Loop through NFC tag records
        for (var i = 0; i < cachedMessage.records.length; i++) {
          final record = cachedMessage.records[i];

          // Define how information is stored on the tag (for now, the first record will have tCost)
          final payload = String.fromCharCodes(record.payload);
          final parts = payload.split(':');
          if (parts.length == 2) {
            final tokenCostString = parts[1];
            try {
              // Parse int from data
              final tokenCost = int.parse(tokenCostString);
              // Deduct tokens from user account
              auth.setUserId(); // Set the user ID
              dynamic uid = auth.userID; // Get the user ID from database file
              await DataBaseService(uid: uid)
                  .deductTokens(tokenCost); // Call deduct tokens method
              return NfcState.success; // Return success state
            } catch (e) {
              if (e is InsufficientTokensException) {
                return NfcState
                    .insufficientTokens; // Return insufficient tokens state
              } else {
                throw Exception('Invalid token format or deduction error: $e');
              }
            }
          }
        }
      }
    }
    return NfcState.error; // Return error state if no valid NDEF data is found
  }
}
