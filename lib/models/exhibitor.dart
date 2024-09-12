import 'package:cloud_firestore/cloud_firestore.dart';

/// Class representing an exhibitor
class Exhibitor {
  final String docId;
  final int goldBalanace;
  final int silverBalance;
  final String name;

  Exhibitor({
    required this.docId,
    required this.goldBalanace,
    required this.silverBalance,
    required this.name,
  });

  /// Creates an [Exhibitor] object from Firestore data
  factory Exhibitor.fromFirestore(DocumentSnapshot doc) {
    return Exhibitor(
      docId: doc.id,
      goldBalanace: doc.get('goldBalance'),
      silverBalance: doc.get('silverBalance'),
      name: doc.get('name'),
    );
  }
}
