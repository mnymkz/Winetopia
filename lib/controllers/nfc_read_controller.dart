import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/ndef_record_info.dart';
import 'package:winetopia/models/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database.dart';

/// Controller class for NFC reading sessions
class NfcReadController {
  final BuildContext context; // Access context to use Provider
  final NfcStateModel nfcStateModel;

  NfcReadController({
    required this.context,
    required this.nfcStateModel,
  });

  /// Starts an NFC reading session and modifies the [NfcState] accordingly.
  Future<void> getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            nfcStateModel.updateState(NfcState.error);
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              await _processTag(tag);
            } catch (e) {
              nfcStateModel.updateState(NfcState.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        nfcStateModel.updateState(NfcState.error);
      }
    } else {
      nfcStateModel.updateState(NfcState.notAvailable);
    }
  }

  /// Process the NFC tag to extract NDEF message.
  Future<void> _processTag(NfcTag tag) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          final wineDocId = NdefRecordInfo.fromNdef(record).title;

          // Validate the wine docId and handle the purchase.
          await _handleWinePurchase(wineDocId);
        }
      }
    } else {
      nfcStateModel.updateState(NfcState.error);
    }
  }

  Future<void> _handleWinePurchase(String wineDocId) async {
    try {
      // Access the current user from the Provider
      final WinetopiaUser? currentUser =
          Provider.of<WinetopiaUser?>(context, listen: false);
      if (currentUser == null) {
        nfcStateModel.updateState(NfcState.error);
        return;
      }

      final uid = currentUser.uid; // Get the user ID
      final dbService = DataBaseService(uid: uid);
      final wineSample = await dbService.getWineInfo(wineDocId);

      if (wineSample != null) {
        // Deduct tokens from attendee account, add to exhibitor account, and add wine to attendee purchases list
        await dbService.purchaseWine(wineSample.docId);
        nfcStateModel.updateState(NfcState.success);
      } else {
        nfcStateModel.updateState(NfcState.error);
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        nfcStateModel.updateState(NfcState.insufficientTokens);
      } else {
        nfcStateModel.updateState(NfcState.error);
      }
    }
  }
}
