import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/models/nfc_state.dart';

/// A circular button that indicates NFC reading state.
/// Changes appearance based on the [nfcState] provided.
class NfcReadButton extends StatelessWidget {
  const NfcReadButton({super.key, required this.nfcState});

  final NfcState nfcState; // Current state of the NFC operation

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    Color borderColor;

    switch (nfcState) {
      case NfcState.scanning:
        icon = CupertinoIcons.radiowaves_right;
        iconColor = Colors.purple;
        backgroundColor = Colors.white;
        borderColor = Colors.purple;
        break;
      case NfcState.success:
        icon = Icons.check;
        iconColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green;
        break;
      case NfcState.error:
      case NfcState.notAvailable:
      case NfcState.insufficientTokens:
        icon = Icons.close;
        iconColor = Colors.red;
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
        break;
      case NfcState.idle:
      default:
        icon = CupertinoIcons.radiowaves_right;
        iconColor = Colors.white;
        backgroundColor = const Color(0xFF99E4EF);
        borderColor = const Color(0xFF3ACAE2);
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 3.0,
        ),
        boxShadow: nfcState == NfcState.scanning
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(6, 2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 40,
          color: iconColor,
        ),
      ),
    );
  }
}
