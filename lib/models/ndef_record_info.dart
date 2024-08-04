import 'package:nfc_manager/nfc_manager.dart';
import 'package:winetopia/models/ndef_record.dart';

/// Holds information about an NDEF record, including the text content.
///
/// Only supports well-known NFC record type data.
class NdefRecordInfo {
  const NdefRecordInfo({required this.record, required this.title});

  final Record record;
  final String title;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final _record = Record.fromNdef(record);
    if (_record is WellknownTextRecord) {
      return NdefRecordInfo(
        record: _record,
        title: _record.text,
      );
    }
    throw UnimplementedError(); // Throws error if the record type is not supported.
  }
}
