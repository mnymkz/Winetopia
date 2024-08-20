import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/exhibitor.dart';
import 'package:winetopia/models/transaction.dart';
import 'package:winetopia/models/wine_sample.dart';
import 'package:winetopia/models/winetopia_user.dart';

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
  final CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('transaction');

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

  /// Get wine information from database
  Future<WineSample?> getWineInfo(String wineDocId) async {
    DocumentSnapshot wineDoc = await wineCollection.doc(wineDocId).get();
    if (wineDoc.exists) {
      return WineSample.fromFirestore(wineDoc);
    }
    return null; // Handle case where wine is not found or exhibitor is null
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

  /// Get transaction information from the database
  Future<WineTransaction?> getWineTransactionInfo(String transactionId) async {
    DocumentSnapshot docSnapshot =
        await transactionCollection.doc(transactionId).get();

    if (docSnapshot.exists) {
      return WineTransaction.fromFirestore(docSnapshot);
    } else {
      return null;
    }
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

      // Log the transaction and get the transaction ID
      String transactionId = await logTransaction(wineSample);

      // Add the transction Id  to the attendee's wineTransactions list
      await addToAttendeeWineTransactions(transactionId);

      // Update the exhibitor's balance
      await addTokensToExhibitor(
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

  /// Log the transaction in the transaction collection
  Future<String> logTransaction(WineSample wineSample) async {
    try {
      WineTransaction transaction = WineTransaction(
        attendeeId: uid,
        wineSample: wineSample,
        exhibitor: wineSample.exhibitor,
      );

      DocumentReference docRef =
          await transactionCollection.add(transaction.toFirestore());

      // Return the document ID (transaction ID)
      return docRef.id;
    } catch (e) {
      throw Exception('Error logging transaction: $e');
    }
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

  /// Add a transaction doc ID to the user's wineTransactions list in the database
  Future<void> addToAttendeeWineTransactions(String transactionId) async {
    DocumentReference userDoc = attendeeCollection.doc(uid);

    // Add the transaction ID to the wineTransactions array
    return await userDoc.update({
      'wineTransactions': FieldValue.arrayUnion([transactionId]),
    });
  }

  /// Add tokens to the exhibitor's balance in database
  Future<void> addTokensToExhibitor(
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

  /// Get the list of wine trasaction docIds for the attendee
  Future<List<String>> getWineTransactionIds() async {
    DocumentSnapshot userDoc = await attendeeCollection.doc(uid).get();
    if (userDoc.exists) {
      List<dynamic> wineTransactions = userDoc.get('wineTransactions') ?? [];
      return List<String>.from(wineTransactions);
    } else {
      return []; // Handle case where user document is not found
    }
  }

  /// Get the list of WineTransaction objects for the attendee
  Future<List<WineTransaction>> getWineTransactions() async {
    try {
      // Step 1: Fetch the transaction IDs for the attendee
      List<String> transactionIds = await getWineTransactionIds();

      List<WineTransaction> wineTransactions = [];

      // Step 2: Loop through each transaction ID and fetch corresponding data
      for (String transactionId in transactionIds) {
        // Fetch the transaction document from Firestore
        WineTransaction? wineTransaction =
            await getWineTransactionInfo(transactionId);

        if (wineTransaction != null) {
          wineTransactions.add(wineTransaction);
        }
      }

      // Step 3: Return the list of wine transactions
      return wineTransactions;
    } catch (e) {
      throw Exception('Error fetching wine transactions: $e');
    }
  }
}

class InsufficientTokensException implements Exception {
  final String message;
  InsufficientTokensException(this.message);

  @override
  String toString() => message;
}
