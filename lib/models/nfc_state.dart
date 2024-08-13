import 'package:flutter/foundation.dart';

class NfcStateModel extends ChangeNotifier {
  NfcState _state = NfcState.idle; // Initial state is idle

  NfcState get state => _state;

  void updateState(NfcState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}

/// Defines the possible states for NFC operations and their associated feedback messages.
enum NfcState {
  idle('Tap to pay for a wine sample', ''),
  scanning('Scanning...', ''),
  success('Purchase successful!', 'Tap again to buy another wine sample.'),
  insufficientTokens(
      'Oops', 'Looks like you don\'t have enough tokens for this wine sample'),
  error('An error occurred while scanning.', 'Press the button to try again.'),
  notAvailable('NFC unavailable or turned off',
      'Please turn on your device\'s NFC settings or check if it is available.');

  final String primaryMessage; // Primary feedback message.
  final String secondaryMessage; // Secondary feedback message.

  /// Creates an instance of the [NfcState] with the provided messages.
  const NfcState(this.primaryMessage, this.secondaryMessage);
}
