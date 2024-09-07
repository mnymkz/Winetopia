import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/exhibitor.dart';
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
  CollectionReference get transactionHistoryCollection {
    return attendeeCollection.doc(uid).collection('transactionHistory');
  }

  //update userData, this should be use for registration only
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

  //delete profile
  Future deleteProfile(String uid) async {
    await attendeeCollection.doc(uid).delete();
  }

  //update user profile in firebase
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

  // UserData from snapshot
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

  // Get attendee stream
  Stream<UserData> get userData {
    return attendeeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Stream for current user's wine transactions
  Stream<List<WineTransaction>> get allTransactions {
    return transactionHistoryCollection
        .orderBy('purchaseTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return WineTransaction.fromFirestore(doc);
      }).toList();
    });
  }

  /// Handle the wine purchase process.
  Future<WineSample?> purchaseWine(String wineDocId) async {
    try {
      final wineSample = await getWineInfo(wineDocId);
      if (wineSample == null) {
        throw Exception('Wine not found');
      }

      // Deduct tokens from attendee
      await deductTokensFromAttendee(wineSample.tPrice, wineSample.isGold);

      // Record the transaction in the attendee's transactions subcollection
      await recordTransaction(wineSample);

      // Update the exhibitor's balance
      await updateExhibitorBalance(
          wineSample.exhibitor.docId, wineSample.tPrice, wineSample.isGold);

      return wineSample; // Return success state
    } catch (e) {
      if (e is InsufficientTokensException) {
        rethrow; // Propagate the custom exception
      } else {
        throw Exception('Error processing wine purchase: $e');
      }
    }
  }

  // Record the transaction
  Future<void> recordTransaction(WineSample wineSample) async {
    await transactionHistoryCollection.add({
      'wineId': wineSample.docId,
      'wineName': wineSample.name,
      'exhibitorName': wineSample.exhibitor.name,
      'cost': wineSample.tPrice,
      'isGoldPurchase': wineSample.isGold,
      'purchaseTime': FieldValue.serverTimestamp(),
    });
  }

  /*
   * deductTokens function deducts tokens from the user's account 
   * 
   * @param numToken the number of tokens to dedeuct from the user's account
   * @param isGold indicates whether to deduct from goldTokens or silverTokens
   */
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

  /// Get exhibitor information from database
  Future<Exhibitor?> getExhibitorInfo(String exhibitorDocId) async {
    DocumentSnapshot docSnapshot =
        await exhibitorCollection.doc(exhibitorDocId).get();
    if (docSnapshot.exists) {
      return Exhibitor.fromFirestore(docSnapshot);
    } else {
      return null; // Handle case where exhibitor is not found
    }
  }

  /// Add tokens to the exhibitor's balance in database
  Future<void> updateExhibitorBalance(
      String exhibitorDocId, int numTokens, bool isGold) async {
    try {
      DocumentReference exhibitorDoc = exhibitorCollection.doc(exhibitorDocId);
      DocumentSnapshot docSnapshot = await exhibitorDoc.get();

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

  /// Check if wine exists in the wine collection
  Future<bool> validateWine(String wineDocId) async {
    DocumentSnapshot docSnapshot = await wineCollection.doc(wineDocId).get();
    return docSnapshot.exists;
  }

  /// Add a wine reference to the user's purchased wines list in database
  Future<void> addPurchasedWine(String wineDocId) async {
    DocumentReference userDoc = attendeeCollection.doc(uid);

    // Add the wineDocId to an array of purchased wine references
    return await userDoc.update({
      'purchasedWines': FieldValue.arrayUnion([wineDocId]),
    });
  }

  /// Get wine information from database
  Future<WineSample?> getWineInfo(String wineDocId) async {
    try {
      DocumentSnapshot wineDoc = await wineCollection.doc(wineDocId).get();
      if (wineDoc.exists) {
        DocumentReference exhibitorRef =
            wineDoc.get('exhibitorId') as DocumentReference;
        Exhibitor? exhibitor = await getExhibitorInfo(exhibitorRef.id);
        if (exhibitor != null) {
          return WineSample.fromFirestore(wineDoc, exhibitor);
        }
      }
      return null; // Handle case where wine is not found or exhibitor is null
    } catch (e) {
      throw Exception('Error fetching wine sample with exhibitor: $e');
    }
  }

  /// Get the list of purchased wine docIds for the attendee
  Future<List<String>> getPurchasedWineIds() async {
    DocumentSnapshot userDoc = await attendeeCollection.doc(uid).get();
    if (userDoc.exists) {
      List<dynamic> purchasedWines = userDoc.get('purchasedWines') ?? [];
      return List<String>.from(purchasedWines);
    } else {
      return []; // Handle case where user document is not found
    }
  }

  /// Get the list of purchased wines for the attendee
  Future<List<WineSample>> getPurchasedWines() async {
    List<String> wineIds = await getPurchasedWineIds();
    List<WineSample> wines = [];

    for (String wineId in wineIds) {
      WineSample? wine = await getWineInfo(wineId);
      if (wine != null) {
        wines.add(wine);
      }
    }
    return wines;
  }
}

class InsufficientTokensException implements Exception {
  final String message;
  InsufficientTokensException(this.message);

  @override
  String toString() => message;
}
