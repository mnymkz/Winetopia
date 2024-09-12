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

  /// Handles the purchase of a wine sample by performing several actions in a transaction.
  Future<WineSample?> purchaseWine(String wineDocId) async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Retrieve wine sample from database
      final wineSample = await getWineInfo(wineDocId);
      if (wineSample == null) {
        throw Exception('Wine not found');
      }

      // Reference to current attendee's document
      DocumentReference userDoc = attendeeCollection.doc(uid);
      DocumentSnapshot userSnapshot = await transaction.get(userDoc);

      // Reference to exhibitor's document
      DocumentReference exhibitorDoc =
          exhibitorCollection.doc(wineSample.exhibitorId);
      DocumentSnapshot exhibitorSnapshot = await transaction.get(exhibitorDoc);

      // Deduct tokens from attendee
      int currentTokenAmount = wineSample.isGold
          ? (userSnapshot.get('goldTokens') ?? 0)
          : (userSnapshot.get('silverTokens') ?? 0);
      if (currentTokenAmount < wineSample.tPrice) {
        throw InsufficientTokensException('Not enough tokens');
      }
      transaction.update(userDoc, {
        wineSample.isGold ? 'goldTokens' : 'silverTokens':
            currentTokenAmount - wineSample.tPrice,
      });

      // Record the wine transaction in attendee account
      transaction.set(userTransactionHistoryCollection.doc(), {
        'wineId': wineSample.docId,
        'wineName': wineSample.name,
        'exhibitorId': wineSample.exhibitorId,
        'exhibitorName': wineSample.exhibitorName,
        'cost': wineSample.tPrice,
        'isGoldPurchase': wineSample.isGold,
        'purchaseTime': FieldValue.serverTimestamp(),
      });

      // Update exhibitor's balance
      int exhibitorCurrentBalance = wineSample.isGold
          ? (exhibitorSnapshot.get('goldBalance') ?? 0)
          : (exhibitorSnapshot.get('silverBalance') ?? 0);
      transaction.update(exhibitorDoc, {
        wineSample.isGold ? 'goldBalance' : 'silverBalance':
            exhibitorCurrentBalance + wineSample.tPrice,
      });

      return wineSample;
    });
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

/*
 * addTokens function adds tokens to the user's account 
 * 
 * @param numTokens the number of tokens to add to the user's account
 * @param isGold indicates whether to add to goldTokens or silverTokens
 */
  Future<bool> addTokensToAttendee(int numTokens, bool isGold) async {
    try {
      DocumentReference userDoc = attendeeCollection.doc(uid);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Get the current token balance based on isGold
        int currentTokenAmount = isGold
            ? (docSnapshot.get('goldTokens') ?? 0)
            : (docSnapshot.get('silverTokens') ?? 0);

        // Add the tokens to the correct balance
        await userDoc.update({
          isGold ? 'goldTokens' : 'silverTokens':
              currentTokenAmount + numTokens,
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error updating token amount: $e');
    }
  }
}

class InsufficientTokensException implements Exception {
  final String message;
  InsufficientTokensException(this.message);

  @override
  String toString() => message;
}
