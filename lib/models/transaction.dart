import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/exhibitor.dart';
import 'package:winetopia/models/wine_sample.dart';

class WineTransaction {
  final String attendeeId;
  final WineSample wineSample;
  final Exhibitor exhibitor;
  Timestamp? timestamp;

  WineTransaction({
    required this.attendeeId,
    required this.wineSample,
    required this.exhibitor,
    this.timestamp,
  });

  // Convert WineTransaction to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'attendeeId': attendeeId,
      'wineSample': wineSample.docId, // Convert WineSample to Firestore
      'exhibitor': exhibitor.docId, // Convert Exhibitor to Firestore
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  // Returns a WineTransaction object from Firestore document snapshot
  factory WineTransaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WineTransaction(
      attendeeId: data['attendeeId'],
      wineSample: WineSample.fromFirestore(data['wineSample']),
      exhibitor: Exhibitor.fromFirestore(data['exhibitor']),
      timestamp: data['timestamp'],
    );
  }
}
