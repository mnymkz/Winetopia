import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database.dart';

class AuthService {
  // the '_<variable name>' means this variable is private

  //get the firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firebaseErrorCode = '';
  String? userID = '';

  //create user object base on FirebaseUser (models/user.dart)
  //WinetopiaUser is an instance that store all the information we need from the FirebaseUser instance
  WinetopiaUser? _userFromFirebaseUser(User? user) {
    return user != null ? WinetopiaUser(uid: user.uid) : null;
  }

  //Auth change user stream
  Stream<WinetopiaUser?> get user {
    //authStateChanges() is to notify about changes to the user's sign-in state
    //mapping the User instance from firebase into a WinetopiaUser instance
    //this function listen to the stream and return a Winetopia instance when there is change
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously(); //wait for the _auth to sign in then return an UserCredential object
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user); //return the Winetopia user create by Firebase user intance
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future resigterWithEmailAndPassword(String email, String password, String fname, String lname, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //create a new document for the user with the uid
      await DataBaseService(uid: user!.uid)
          .updateUserData(email, fname, lname, phone, 0);

      return _userFromFirebaseUser(user); //return the Winetopia user create by Firebase user intance
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return null;
    }
  }

  //update user profile
  Future updateEmail() async{
    try {
      _auth.currentUser!.updatePassword('');
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteAccount() async {
    try {
      // delete the current user's firestore database document
      await DataBaseService(uid: _auth.currentUser!.uid).deleteUserData();

      // delete the current user's firebase authentication account
      await _auth.currentUser!.delete();
      
      // account deleted successfully
      return null; 

    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return e.code; // return the error code if an issue occurs
    }
  }


  // Method to get the current user's uid
  // call function before accessing the user id
  void setUserId() {
    User? user = _auth.currentUser;
    userID = user?.uid;
  }
}


