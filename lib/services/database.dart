import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{

  final String uid;
  
  DataBaseService({required this.uid});

  //collection reference
  final CollectionReference attendee = FirebaseFirestore.instance.collection('attendee');

  Future updateUserData(String email, String fname, String lname, String phone, int tokenAmount) async{
    return await attendee.doc(uid).set({
      'email' : email,
      'fname' : fname,
      'lname' : lname,
      'phone' : phone,
      'tokenAmount' : tokenAmount,
    });
  }

}