import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winetopia/controllers/nfc_read_controller.dart';
import 'package:winetopia/shared/nfc_state.dart';

/// A button that initiates the NFC reading session.
/// Changes appearance based on the [NfcState] stream.
class NfcButton extends StatelessWidget {
  const NfcButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NfcState>(
      builder: (context, nfcStateModel, child) {
        final buttonStyle = _getButtonStyle(nfcStateModel.state);

        return Column(
          children: [
            GestureDetector(
              onTap: () => _nfcButtonPressed(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: buttonStyle['backgroundColor'],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: buttonStyle['borderColor'],
                    width: 3.0,
                  ),
                  boxShadow: nfcStateModel.state == NfcStateEnum.scanning
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
                    buttonStyle['icon'],
                    size: 40,
                    color: buttonStyle['iconColor'],
                  ),
                ),
              ),
            ),

            // Primary feedback messages
            Center(
              child: Text(
                nfcStateModel.state.primaryMessage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            // Secondary feedback message
            Center(
              child: Text(
                nfcStateModel.state.secondaryMessage,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  /// Initiates the NFC reading process and updates the NFC state based on the result
  void _nfcButtonPressed(BuildContext context) async {
    final nfcStateStream = Provider.of<NfcState>(context, listen: false);
    nfcStateStream.updateState(NfcStateEnum.scanning);

    final nfcReadController = NfcReadController(
      nfcStateModel: nfcStateStream,
      context: context,
    );

    await nfcReadController.getNfcData(); // Start the NFC reading process
  }

  /// Returns a map of styles based on the NFC state.
  Map<String, dynamic> _getButtonStyle(NfcStateEnum state) {
    switch (state) {
      case NfcStateEnum.scanning:
        return {
          'icon': CupertinoIcons.radiowaves_right,
          'iconColor': Colors.purple,
          'backgroundColor': Colors.white,
          'borderColor': Colors.purple
        };
      case NfcStateEnum.success:
        return {
          'icon': Icons.check,
          'iconColor': Colors.green,
          'backgroundColor': Colors.green.shade50,
          'borderColor': Colors.green
        };
      case NfcStateEnum.error:
      case NfcStateEnum.notAvailable:
      case NfcStateEnum.insufficientTokens:
        return {
          'icon': Icons.close,
          'iconColor': Colors.red,
          'backgroundColor': Colors.red.shade50,
          'borderColor': Colors.red
        };
      case NfcStateEnum.idle:
      default:
        return {
          'icon': CupertinoIcons.radiowaves_right,
          'iconColor': Colors.white,
          'backgroundColor': const Color(0xFF99E4EF),
          'borderColor': const Color(0xFF3ACAE2)
        };
    }
  }
}
