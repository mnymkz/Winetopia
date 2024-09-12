/// Manages the NFC State.
class NfcState {
  NfcStateEnum state;

  NfcState({
    this.state = NfcStateEnum.idle,
  });

  void updateState(NfcStateEnum newState) {
    state = newState;
  }
}

/// Defines the possible states for NFC operations and their feedback messages.
enum NfcStateEnum {
  idle('Tap the button to buy your wine', ''),
  scanning('Scanning...', ''),
  success('Success!', 'Tap again to buy another wine sample.'),
  insufficientTokens('Oops, not enough tokens', 'Please top up to continue'),
  error('An error occurred while scanning.', 'Press the button to try again.'),
  notAvailable('NFC unavailable', 'Please turn on your NFC settings');

  final String primaryMessage;
  final String secondaryMessage;

  /// Creates an instance of the [NfcStateEnum] with the provided messages.
  const NfcStateEnum(this.primaryMessage, this.secondaryMessage);
}
