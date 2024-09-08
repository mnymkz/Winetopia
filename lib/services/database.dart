import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/wine_sample.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/models/wine_transaction.dart';

class DataBaseService {
  final String uid;

  DataBaseService({required this.uid});

  // Collection references
  final CollectionReference attendeeCollection =
      FirebaseFirestore.instance.collection('attendee');
  final CollectionReference wineCollection =
      FirebaseFirestore.instance.collection('wine');
  final CollectionReference exhibitorCollection =
      FirebaseFirestore.instance.collection('exhibitor');

  // Transactions subcollection under attendee
  CollectionReference get userTransactionHistoryCollection {
    return attendeeCollection.doc(uid).collection('transactionHistory');
  }

  /// Update userData, this should be use for registration only
  Future updateUserData(String email, String fname, String lname, String phone,
      int goldTokens, int silverTokens) async {
    return await attendeeCollection.doc(uid).set({
      'email': email,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'goldTokens': goldTokens,
      'silverTokens': silverTokens,
    });
  }

  /// Delete profile
  Future deleteProfile(String uid) async {
    await attendeeCollection.doc(uid).delete();
  }

  /// Update user profile in firebase
  Future updateProfile(
      String email, String fname, String lname, String phone) async {
    return await attendeeCollection.doc(uid).update({
      'email': email,
      'fname': fname,
      'lname': lname,
      'phone': phone,
    });
  }

  Future updateEmail(String? email) async {
    return await attendeeCollection.doc(uid).update({'email': email});
  }

  Future updateFirstName(String fname) async {
    return await attendeeCollection.doc(uid).update({'fname': fname});
  }

  Future updateLastName(String lname) async {
    return await attendeeCollection.doc(uid).update({'lname': lname});
  }

  Future updatePhone(String phone) async {
    return await attendeeCollection.doc(uid).update({'phone': phone});
  }

  /// UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        email: snapshot.get('email'),
        fname: snapshot.get('fname'),
        lname: snapshot.get('lname'),
        phone: snapshot.get('phone'),
        goldTokens: snapshot.get('goldTokens'),
        silverTokens: snapshot.get('silverTokens'));
  }

  /// Get attendee stream
  Stream<UserData> get userData {
    return attendeeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Stream for current user's wine transaction history
  Stream<List<WineTransaction>> get allTransactions {
    return userTransactionHistoryCollection
        .orderBy('purchaseTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return WineTransaction.fromFirestore(doc);
      }).toList();
    });
  }

  /// Handle the wine purchase.
  Future<WineSample?> purchaseWine(String wineDocId) async {
    try {
      final wineSample = await getWineInfo(wineDocId);
      if (wineSample == null) {
        throw Exception('Wine not found');
      }

      // Deduct tokens from attendee
      await deductTokensFromAttendee(wineSample.tPrice, wineSample.isGold);

      // Record the transaction in the attendee's transactions subcollection
      await recordTransactionInUserHistory(wineSample);

      // Update the exhibitor's balance
      await updateExhibitorBalance(
          wineSample.exhibitorId, wineSample.tPrice, wineSample.isGold);

      return wineSample; // Return success state
    } catch (e) {
      if (e is InsufficientTokensException) {
        rethrow; // Propagate the custom exception
      } else {
        throw Exception('Error processing wine purchase: $e');
      }
    }
  }

  /// Get wine information from database
  Future<WineSample?> getWineInfo(String wineDocId) async {
    try {
      DocumentSnapshot wineDoc = await wineCollection.doc(wineDocId).get();
      if (wineDoc.exists) {
        return WineSample.fromFirestore(wineDoc);
      }
      return null; // Wine not found in the database
    } catch (e) {
      throw Exception('Error fetching wine sample with exhibitor: $e');
    }
  }

  /// Deducts tokens from the user's account
  Future<void> deductTokensFromAttendee(int numTokens, bool isGold) async {
    try {
      DocumentReference userDoc = attendeeCollection.doc(uid);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Get the appropriate token balance based on isGold
        int currentTokenAmount = isGold
            ? (docSnapshot.get('goldTokens') ?? 0)
            : (docSnapshot.get('silverTokens') ?? 0);

        if (currentTokenAmount >= numTokens) {
          // Deduct the tokens from the correct balance
          await userDoc.update({
            isGold ? 'goldTokens' : 'silverTokens':
                currentTokenAmount - numTokens,
          });
        } else {
          throw InsufficientTokensException('Not enough tokens');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        rethrow; // Re-throw the custom exception
      } else {
        throw Exception('Error updating token amount: $e');
      }
    }
  }

  /// Record the transaction in user's transaction history
  Future<void> recordTransactionInUserHistory(WineSample wineSample) async {
    await userTransactionHistoryCollection.add({
      'wineId': wineSample.docId,
      'wineName': wineSample.name,
      'exhibitorId': wineSample.exhibitorId,
      'exhibitorName': wineSample.exhibitorName,
      'cost': wineSample.tPrice,
      'isGoldPurchase': wineSample.isGold,
      'purchaseTime': FieldValue.serverTimestamp(),
    });
  }

  /// Add tokens to the exhibitor's balance in database
  Future<void> updateExhibitorBalance(
      String exhibitorId, int numTokens, bool isGold) async {
    try {
      DocumentReference exhibitorDoc = exhibitorCollection.doc(exhibitorId);
      DocumentSnapshot docSnapshot =
          await exhibitorCollection.doc(exhibitorId).get();

      if (docSnapshot.exists) {
        // Get the appropriate balance based on isGold
        int currentBalance = isGold
            ? (docSnapshot.get('goldBalance') ?? 0)
            : (docSnapshot.get('silverBalance') ?? 0);

        // Add the tokens to the correct balance
        await exhibitorDoc.update({
          isGold ? 'goldBalance' : 'silverBalance': currentBalance + numTokens,
        });
      } else {
        throw Exception('Exhibitor not found');
      }
    } catch (e) {
      throw Exception('Error updating exhibitor balance: $e');
    }
  }
}

class InsufficientTokensException implements Exception {
  final String message;
  InsufficientTokensException(this.message);

  @override
  String toString() => message;
}
