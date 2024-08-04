/// Defines the possible states for NFC operations and their associated feedback messages.
enum NfcState {
  idle('Tap to pay for a wine sample'),
  scanning('Scanning...'),
  success('Success'),
  error('Error occurred during NFC session'),
  notAvailable('Please turn on your device\'s NFC reading');

  final String feedbackMessage; // Message to display based on the NFC state.

  /// Creates an instance of the [NfcState] with the provided [feedbackMessage].
  const NfcState(this.feedbackMessage);
}
