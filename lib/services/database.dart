import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{

  final String uid;
  
  DataBaseService({required this.uid});

  //collection reference
  final CollectionReference attendeeCollection = FirebaseFirestore.instance.collection('attendee');

  Future updateUserData(String fname, String lname, int tokenAmount) async{
    return await attendeeCollection.doc(uid).set({
      'fname' : fname,
      'lname' : lname,
      'tokenAmount' : tokenAmount,
    });
  }

  //get attendee stream
  Stream<QuerySnapshot> get attendees{
    return attendeeCollection.snapshots();
  }
}