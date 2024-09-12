import 'package:cloud_firestore/cloud_firestore.dart';

/// Class representing a wine sample
class WineSample {
  final String docId;
  final String desc;
  final String name;
  final int tPrice;
  final String exhibitorId;
  final String exhibitorName;
  final bool isGold;

  WineSample({
    required this.docId,
    required this.desc,
    required this.name,
    required this.tPrice,
    required this.exhibitorId,
    required this.exhibitorName,
    required this.isGold,
  });

  /// Creates a [WineSample] object from Firestore data
  factory WineSample.fromFirestore(DocumentSnapshot doc) {
    return WineSample(
      docId: doc.id,
      desc: doc.get('desc'),
      name: doc.get('name'),
      tPrice: doc.get('tPrice'),
      exhibitorId: doc.get('exhibitorId'),
      exhibitorName: doc.get('exhibitorName'),
      isGold: doc.get('isGold'),
    );
  }
}
