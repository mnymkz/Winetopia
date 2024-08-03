import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A circular button that indicates NFC reading state.
/// Changes appearance based on whether it is reading or not.
class NfcReadButton extends StatelessWidget {
  const NfcReadButton({
    super.key,
    required bool isReading,
  }) : _isReading = isReading;

  final bool _isReading;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 250.0,
      height: 250.0,
      decoration: BoxDecoration(
        color: _isReading ? Colors.white : Colors.purple,
        shape: BoxShape.circle,
        border: _isReading
            ? Border.all(
                color: Colors.purple,
                width: 3.0,
              )
            : null, // No border when not reading
        boxShadow: _isReading
            ? [] // No shadow when reading
            : [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(6, 6),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.radiowaves_right,
          size: 100,
          color: _isReading ? Colors.purple : Colors.white,
        ),
      ),
    );
  }
}
