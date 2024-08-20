import 'package:cloud_firestore/cloud_firestore.dart';

class WineTransaction {
  final String attendeeId;
  final String wineDocId;
  final String exhibitorId;
  final Timestamp? timestamp;

  WineTransaction({
    required this.attendeeId,
    required this.wineDocId,
    required this.exhibitorId,
    this.timestamp,
  });

  // Convert Transaction to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'attendeeId': attendeeId,
      'wineDocId': wineDocId,
      'exhibitorId': exhibitorId,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  // Returns a Transaction object from Transaction document snapshot
  factory WineTransaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WineTransaction(
      attendeeId: data['attendeeId'],
      wineDocId: data['wineDocId'],
      exhibitorId: data['exhibitorId'],
      timestamp: data['timestamp'],
    );
  }
}
