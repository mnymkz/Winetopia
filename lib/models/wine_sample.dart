import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/exhibitor.dart';

/// Class representing a wine sample
class WineSample {
  final String docId;
  final String desc;
  final String name;
  final int tPrice;
  final Exhibitor exhibitor;
  final bool isGold;

  WineSample({
    required this.docId,
    required this.desc,
    required this.name,
    required this.tPrice,
    required this.exhibitor,
    required this.isGold,
  });

  /// Returns a wine sample object from wine document snapshot
  factory WineSample.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WineSample(
      docId: doc.id,
      desc: data['desc'],
      name: data['name'],
      tPrice: data['tPrice'],
      exhibitor: Exhibitor.fromFirestore(data['exhibitor']),
      isGold: doc.get('isGold'),
    );
  }
}
