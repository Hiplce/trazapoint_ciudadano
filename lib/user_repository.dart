import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trazapoint_ciudadano/server_api/sever_api.dart';


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

  Future<void> insertUser(String email, String password,String name,String lastname,String dni,String location,String direction,String phone) async {
    var client = TrazaService.getClient();
    String body = email + '|' + password + '|' + name + '|' + lastname + '|' + dni + '|' + location + '|' + direction + '|' + phone;
    return await client.insertPersona(body);

  }
  Future<void> insertTraza(String dni,String idlocal) async {
    var client = TrazaService.getClient();
    String body = idlocal + '|' + dni + '|' + DateTime.now().toString().substring(0, 19);
    return await client.insertTraza(body);

  }
}