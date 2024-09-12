import 'package:flutter/foundation.dart';

/// Manages the current state of NFC operations and notifies listeners of state changes.
class NfcState extends ChangeNotifier {
  NfcStateEnum _state = NfcStateEnum.idle; // Initial state is idle

  NfcStateEnum get state => _state;

  void updateState(NfcStateEnum newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}

/// Defines the possible states for NFC operations and their feedback messages.
enum NfcStateEnum {
  idle('Tap the button to pay for a wine sample', ''),
  scanning('Scanning...', ''),
  success('Enjoy your wine!', 'Tap again to buy another wine sample.'),
  insufficientTokens(
      'Oops, not enough tokens!', 'Please top up and tap again to continue'),
  error('An error occurred while scanning.', 'Press the button to try again.'),
  notAvailable('NFC unavailable or turned off',
      'Please turn on your device\'s NFC settings');

  final String primaryMessage;
  final String secondaryMessage;

  /// Creates an instance of the [NfcStateEnum] with the provided messages.
  const NfcStateEnum(this.primaryMessage, this.secondaryMessage);
}