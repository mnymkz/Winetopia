import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Update userData
  Future updateUserData(String email, String fname, String lname, String phone,
      int tokenAmount) async {
    return await attendeeCollection.doc(uid).set({
      'email': email,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'tokenAmount': tokenAmount,
    });
  }

  // UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        email: snapshot.get('email'),
        fname: snapshot.get('fname'),
        lname: snapshot.get('lname'),
        phone: snapshot.get('phone'),
        tokenAmount: snapshot.get('tokenAmount'));
  }

  // Get attendee stream
  Stream<UserData> get userData {
    return attendeeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  /*
   * deductTokens function deducts tokens from the user's account 
   * 
   * @param numToken the number of tokens to dedeuct from the user's account
   */
  Future<void> deductTokens(int numTokens) async {
    try {
      DocumentReference userDoc = attendeeCollection.doc(uid);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        int currentTokenAmount = docSnapshot.get('tokenAmount') ?? 0;

        if (currentTokenAmount >= numTokens) {
          await userDoc.update({
            'tokenAmount': currentTokenAmount - numTokens,
          });
        } else {
          throw InsufficientTokensException('Not enough tokens');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      if (e is InsufficientTokensException) {
        throw e; // Re-throw the custom exception
      } else {
        print('Error updating token amount: $e');
        throw Exception('Error updating token amount: $e');
      }
    }
  }

  // Check if wine exists in the wine collection
  Future<bool> validateWine(String wineDocId) async {
    DocumentSnapshot docSnapshot = await wineCollection.doc(wineDocId).get();
    return docSnapshot.exists;
  }

  // Add a wine reference to the user's purchased wines list
  Future<void> addPurchasedWine(String wineDocId) async {
    DocumentReference userDoc = attendeeCollection.doc(uid);

    // Add the wineDocId to an array of purchased wine references
    return await userDoc.update({
      'purchasedWines': FieldValue.arrayUnion([wineDocId]),
    });
  }

  // Fetch full wine information using the docId
  Future<WineSample?> getWineInfo(String wineDocId) async {
    DocumentSnapshot docSnapshot = await wineCollection.doc(wineDocId).get();
    if (docSnapshot.exists) {
      return WineSample.fromFirestore(docSnapshot);
    } else {
      return null; // Handle case where wine is not found
    }
  }

  // Get the list of purchased wine docIds for the attendee
  Future<List<String>> getPurchasedWineIds() async {
    DocumentSnapshot userDoc = await attendeeCollection.doc(uid).get();
    if (userDoc.exists) {
      List<dynamic> purchasedWines = userDoc.get('purchasedWines') ?? [];
      return List<String>.from(purchasedWines);
    } else {
      return []; // Handle case where user document is not found
    }
  }

  // Get the list of purchased wines for the attendee
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
