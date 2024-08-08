import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winetopia/models/winetopia_user.dart';

class DataBaseService {
  final String uid;

  DataBaseService({required this.uid});

  //collection reference
  final CollectionReference attendeeCollection = FirebaseFirestore.instance.collection('attendee');

  //update userData
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

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      email: snapshot.get('email'),
      fname: snapshot.get('fname'),
      lname: snapshot.get('lname'),
      phone: snapshot.get('phone'),
      tokenAmount: snapshot.get('tokenAmount')
    );
  }
  //get attendee stream
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
          throw Exception('Not enough tokens');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error updating token amount: $e');
    }
  }
}
