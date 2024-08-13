import 'package:cloud_firestore/cloud_firestore.dart';

class WineSample {
  final String docId;
  final String desc;
  final String exhibitorId;
  final String name;
  final int tPrice;

  WineSample(
      {required this.docId,
      required this.desc,
      required this.exhibitorId,
      required this.name,
      required this.tPrice});

  factory WineSample.fromFirestore(DocumentSnapshot doc) {
    return WineSample(
      docId: doc.id,
      desc: doc.get('description'),
      exhibitorId: doc.get('exhibitorId'),
      name: doc.get('name'),
      tPrice: doc.get('tPrice'),
    );
  }
}
