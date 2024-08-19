import 'package:cloud_firestore/cloud_firestore.dart';

/// Class representing an exhibitor
class Exhibitor {
  final String docId;
  final int bal;
  final String name;

  Exhibitor({
    required this.docId,
    required this.bal,
    required this.name,
  });

  /// Returns an exhibitor object from exhibitor document snapshot
  factory Exhibitor.fromFirestore(DocumentSnapshot doc) {
    return Exhibitor(
      docId: doc.id,
      bal: doc.get('bal'),
      name: doc.get('name'),
    );
  }
}
