import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/models/ndef_record.dart';
import 'package:winetopia/shared/nfc_state.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database_service.dart';

class NfcService {
  // Singleton instance of NfcService
  NfcService._();

  static final NfcService instance = NfcService._();

  Future<void> startNfcSession(
      BuildContext context, Function(NfcStateEnum) onStateUpdate) async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      onStateUpdate(NfcStateEnum.scanning);

      try {
        await NfcManager.instance.startSession(
          onError: (error) async {
            onStateUpdate(NfcStateEnum.error);
            NfcManager.instance.stopSession();
          },
          onDiscovered: (NfcTag tag) async {
            try {
              await _processTag(tag, context, onStateUpdate);
            } catch (e) {
              onStateUpdate(NfcStateEnum.error);
            } finally {
              NfcManager.instance.stopSession();
            }
          },
        );
      } catch (e) {
        onStateUpdate(NfcStateEnum.error);
      }
    } else {
      onStateUpdate(NfcStateEnum.notAvailable);
    }
  }

  Future<void> _processTag(NfcTag tag, BuildContext context,
      Function(NfcStateEnum) onStateUpdate) async {
    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;

      if (cachedMessage != null) {
        for (var record in cachedMessage.records) {
          final wineDocId = NdefRecordInfo.fromNdef(record).title;
          await _handleWinePurchase(wineDocId, context, onStateUpdate);
        }
      }
    } else {
      onStateUpdate(NfcStateEnum.error);
    }
  }

  Future<void> _handleWinePurchase(String wineDocId, BuildContext context,
      Function(NfcStateEnum) onStateUpdate) async {
    try {
      final WinetopiaUser? currentUser =
          Provider.of<WinetopiaUser?>(context, listen: false);
      if (currentUser == null) {
        onStateUpdate(NfcStateEnum.error);
        return;
      }

      final uid = currentUser.uid;
      final dbService = DataBaseService(uid: uid);
      final wineSample = await dbService.purchaseWine(wineDocId);

      if (wineSample != null) {
        onStateUpdate(NfcStateEnum.success);
      } else {
        onStateUpdate(NfcStateEnum.error);
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        onStateUpdate(NfcStateEnum.insufficientTokens);
      } else {
        onStateUpdate(NfcStateEnum.error);
      }
    }
  }
}
