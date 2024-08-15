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
            nfcStateStream.updateState(NfcState.error);
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              final wineSample = await _processTag(tag);
              onWineSamplePurchased(wineSample);
            } catch (e) {
              nfcStateStream.updateState(NfcState.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        nfcStateStream.updateState(NfcState.error);
      }
    } else {
      nfcStateStream.updateState(NfcState.notAvailable);
    }
  }

  /// Process the NFC tag to extract NDEF message.
  Future<WineSample?> _processTag(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          final wineDocId = NdefRecordInfo.fromNdef(record).title;

          // Validate the wine docId and handle the purchase.
          final wineSample = await _handleWinePurchase(wineDocId);
          if (wineSample != null) {
            nfcStateStream.updateState(NfcState.success);
          } else {
            nfcStateStream.updateState(NfcState.error);
          }
          return wineSample;
        }
      }
    }

    nfcStateStream.updateState(NfcState.error);
    return null; // Return error state if no valid NDEF data is found
  }

  Future<WineSample?> _handleWinePurchase(String wineDocId) async {
    try {
      auth.setUserId(); // Set the user ID
      dynamic uid = auth.userID; // Get the user ID

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
        nfcStateStream.updateState(
            NfcState.insufficientTokens); // Return insufficient tokens state
        return null;
      } else {
        // Error processing wine purchase
        return null;
      }
    }
  }
}
