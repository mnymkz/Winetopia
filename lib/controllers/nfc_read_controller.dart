import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/nfc_state.dart';

/// Provides methods for starting and managing NFC reading sessions.
class NfcReadController {
  /// Starts an NFC reading session and returns the resulting [NfcState].
  static Future<NfcState> getNfcData(
      Function onError, Function onDiscovered) async {
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
            onDiscovered(tag);
            NfcManager.instance.stopSession();
            completer.complete(NfcState.success);
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
}
