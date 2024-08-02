import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:winetopia/models/winetopia_user.dart';

class AuthService {
  // the '_<variable name>' means this variable is private

  //get the firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  
  //create user object base on FirebaseUser (models/user.dart)
  //WinetopiaUser is an instance that store all the information we need from the FirebaseUser instance
  WinetopiaUser? _userFromFirebaseUser(User? user){
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
  Future signInAnon() async{
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

  //register with email and password
  Future resigterWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);//return the Winetopia user create by Firebase user intance
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}