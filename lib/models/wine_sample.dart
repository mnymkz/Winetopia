import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/exhibitor.dart';

class WineSample {
  final String docId;
  final String desc;
  final String name;
  final int tPrice;
  final Exhibitor exhibitor;

  WineSample({
    required this.docId,
    required this.desc,
    required this.name,
    required this.tPrice,
    required this.exhibitor,
  });

  factory WineSample.fromFirestore(DocumentSnapshot doc, Exhibitor exhibitor) {
    return WineSample(
      docId: doc.id,
      desc: doc.get('desc'),
      name: doc.get('name'),
      tPrice: doc.get('tPrice'),
      exhibitor: exhibitor,
    );
  }
}
