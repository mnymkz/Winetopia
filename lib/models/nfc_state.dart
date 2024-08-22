import 'package:flutter/foundation.dart';
import 'dart:async';

class NfcStateStream {
  final _controller = StreamController<NfcState>.broadcast();

  // Getter for the stream
  Stream<NfcState> get stream => _controller.stream;

  // Function to add new state to the stream
  void updateState(NfcState newState) {
    _controller.add(newState);
  }

  // Dispose the controller when no longer needed
  void dispose() {
    _controller.close();
  }
}

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
  success('Enjoy your wine!', 'Tap again to buy another wine sample.'),
  insufficientTokens('Oops, not enough tokens!',
      'Please top up your tokens to continue your purchase'),
  error('An error occurred while scanning.', 'Press the button to try again.'),
  notAvailable('NFC unavailable or turned off',
      'Please turn on your device\'s NFC settings or check if it is available.');

  final String primaryMessage; // Primary feedback message.
  final String secondaryMessage; // Secondary feedback message.

  /// Creates an instance of the [NfcState] with the provided messages.
  const NfcState(this.primaryMessage, this.secondaryMessage);
}
