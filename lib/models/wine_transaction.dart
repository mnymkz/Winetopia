import 'package:cloud_firestore/cloud_firestore.dart';

/// Class representing a wine transaction
class WineTransaction {
  final String docId;
  final String wineId;
  final String wineName;
  final String exhibitorId;
  final String exhibitorName;
  final int cost;
  final bool isGoldPurchase;
  final DateTime purchaseTime;

  WineTransaction({
    required this.docId,
    required this.wineId,
    required this.wineName,
    required this.exhibitorId,
    required this.exhibitorName,
    required this.cost,
    required this.isGoldPurchase,
    required this.purchaseTime,
  });

  /// Creates a [WineTransaction] from Firestore data
  factory WineTransaction.fromFirestore(DocumentSnapshot doc) {
    return WineTransaction(
      docId: doc.id,
      wineId: doc['wineId'] ?? 'Unknown Wine',
      wineName: doc['wineName'] ?? 'Unknown Wine',
      exhibitorId: doc['exhibitorId'] ?? 'Unknown Exhibitor',
      exhibitorName: doc['exhibitorName'] ?? 'Unknown Exhibitor',
      cost: doc['cost'] ?? 0,
      isGoldPurchase: doc['isGoldPurchase'] ?? false,
      purchaseTime: doc['purchaseTime'] != null
          ? (doc['purchaseTime'] as Timestamp).toDate()
          : DateTime
              .now(), // Fallback to current time if purchaseTime is missing
    );
  }

  /// Converts a [WineTransaction] object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'wineId': wineId,
      'wineName': wineName,
      'exhibitorId': exhibitorId,
      'exhibitorName': exhibitorName,
      'cost': cost,
      'isGoldPurchase': isGoldPurchase,
      'purchaseTime': purchaseTime,
    };
  }
}
