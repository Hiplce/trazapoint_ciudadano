import 'dart:async';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';


class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;


  Future<void> signInWithEmail(String email, String password) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> singUp(String email, String password) async{
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> singOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return await _firebaseAuth.currentUser.email;
  }
}