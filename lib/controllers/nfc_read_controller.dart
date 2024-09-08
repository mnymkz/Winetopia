import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/ndef_record.dart';
import 'package:winetopia/shared/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database.dart';

/// Controller class for NFC reading sessions
class NfcReadController {
  final BuildContext context; // Access context to use Provider
  final NfcState nfcStateModel;

  NfcReadController({
    required this.context,
    required this.nfcStateModel,
  });

  /// Starts an NFC reading session and modifies the [NfcStateEnum] accordingly.
  Future<void> getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            nfcStateModel.updateState(NfcStateEnum.error);
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              await _processTag(tag);
            } catch (e) {
              nfcStateModel.updateState(NfcStateEnum.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        nfcStateModel.updateState(NfcStateEnum.error);
      }
    } else {
      nfcStateModel.updateState(NfcStateEnum.notAvailable);
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
      nfcStateModel.updateState(NfcStateEnum.error);
    }
  }

  Future<void> _handleWinePurchase(String wineDocId) async {
    try {
      // Access the current user from the Provider
      final WinetopiaUser? currentUser =
          Provider.of<WinetopiaUser?>(context, listen: false);
      if (currentUser == null) {
        nfcStateModel.updateState(NfcStateEnum.error);
        return;
      }

      final uid = currentUser.uid; // Get the user ID
      final dbService = DataBaseService(uid: uid);
      // Deduct tokens from attendee account, add to exhibitor account, and add wine to attendee purchases list
      final wineSample = await dbService.purchaseWine(wineDocId);

      if (wineSample != null) {
        nfcStateModel.updateState(NfcStateEnum.success);
      } else {
        nfcStateModel.updateState(NfcStateEnum.error);
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        nfcStateModel.updateState(NfcStateEnum.insufficientTokens);
      } else {
        nfcStateModel.updateState(NfcStateEnum.error);
      }
    }
  }
}
