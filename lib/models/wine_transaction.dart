import 'package:cloud_firestore/cloud_firestore.dart';

class WineTransaction {
  final String wineId;
  final String wineName;
  final String exhibitorName;
  final int cost;
  final bool isGoldPurchase;
  final DateTime purchaseTime;

  WineTransaction({
    required this.wineId,
    required this.wineName,
    required this.exhibitorName,
    required this.cost,
    required this.isGoldPurchase,
    required this.purchaseTime,
  });

  // Factory method to create a Transaction from Firestore data
  factory WineTransaction.fromFirestore(DocumentSnapshot doc) {
    return WineTransaction(
      wineId: doc.id,
      wineName: doc['wineName'] ?? 'Unknown Wine',
      exhibitorName: doc['exhibitorName'] ?? 'Unknown Exhibitor',
      cost: doc['cost'] ?? 0,
      isGoldPurchase: doc['isGoldPurchase'] ?? false,
      purchaseTime: doc['purchaseTime'] != null
          ? (doc['purchaseTime'] as Timestamp).toDate()
          : DateTime
              .now(), // Fallback to current time if purchaseTime is missing
    );
  }

  // Method to convert Transaction object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'wineId': wineId,
      'wineName': wineName,
      'exhibitorName': exhibitorName,
      'cost': cost,
      'isGoldPurchase': isGoldPurchase,
      'purchaseTime': purchaseTime,
    };
  }
}
