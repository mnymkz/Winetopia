import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winetopia/services/nfc_service.dart';
import 'package:winetopia/shared/nfc_state.dart';

class NfcPurchaseButton extends StatefulWidget {
  const NfcPurchaseButton({super.key});

  @override
  State<NfcPurchaseButton> createState() => _NfcPurchaseButtonState();
}

class _NfcPurchaseButtonState extends State<NfcPurchaseButton> {
  NfcState nfcState = NfcState();

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(nfcState.state);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (nfcState.state == NfcStateEnum.scanning)
              Positioned.fill(
                child: RippleAnimation(
                  duration: const Duration(milliseconds: 2000),
                  minRadius: 40,
                  size: const Size(100.0, 100.0),
                  repeat: true,
                  ripplesCount: 6,
                  color: buttonStyle['borderColor'].withOpacity(0.5),
                  child: const SizedBox.expand(),
                ),
              ),
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
                  boxShadow: nfcState.state == NfcStateEnum.scanning
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      buttonStyle['icon'],
                      key: ValueKey(buttonStyle['icon']),
                      size: 40,
                      color: buttonStyle['iconColor'],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Center(
          child: Text(
            nfcState.state.primaryMessage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Center(
          child: Text(
            nfcState.state.secondaryMessage,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _nfcButtonPressed(BuildContext context) async {
    await NfcService.instance.startNfcSession(context, _setNfcState);
    setState(() {}); // Rebuild UI when state changes
  }

  void _setNfcState(NfcStateEnum newState) {
    setState(() {
      nfcState.state = newState;
    });
  }

  Map<String, dynamic> _getButtonStyle(NfcStateEnum state) {
    switch (state) {
      case NfcStateEnum.scanning:
        return {
          'icon': CupertinoIcons.radiowaves_right,
          'iconColor': const Color(0xFF3ACAE2),
          'backgroundColor': Colors.white,
          'borderColor': const Color(0xFF3ACAE2)
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
