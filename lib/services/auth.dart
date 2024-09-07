import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:winetopia/models/winetopia_user.dart';
import 'package:winetopia/services/database.dart';

class AuthService {
  // the '_<variable name>' means this variable is private

  //get the firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firebaseErrorCode = '';
  String? userEmail = '';

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
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth
          .signInAnonymously(); //wait for the _auth to sign in then return an UserCredential object
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
      if (!checkVerifyEmail()) {
        _auth.currentUser!.sendEmailVerification();
      }

      return _userFromFirebaseUser(
          user); //return the Winetopia user create by Firebase user intance
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future resigterWithEmailAndPassword(String email, String password,
      String fname, String lname, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (!checkVerifyEmail()) {
        _auth.currentUser!.sendEmailVerification();
      }

      //create a new document for the user with the uid
      await DataBaseService(uid: user!.uid)
          .updateUserData(email, fname, lname, phone, 0, 0);
      return _userFromFirebaseUser(
          user); //return the Winetopia user create by Firebase user intance
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return null;
    }
  }

  //Changing password
  Future updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return false;
    }
  }

  //Changing email
  Future updateEmail(String newEmail) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return false;
    }
  }

  //Delete account
  Future deleteAccount() async {
    try {
      // throw FirebaseAuthException(
      //   code: 'requires-recent-login',
      //   message: 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.',
      // );
      String uid = _auth.currentUser!.uid;
      await _auth.currentUser!.delete();
      await DataBaseService(uid: uid).deleteProfile(uid);

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      firebaseErrorCode = e.code.toString();
      return false;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String? getUserEmail() {
    User? user = _auth.currentUser;
    return user?.email;
  }

  bool checkVerifyEmail() {
    return _auth.currentUser!.emailVerified;
  }
}
