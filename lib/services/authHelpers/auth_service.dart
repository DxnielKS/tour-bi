import 'dart:ffi';

import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user obj based on the firebase user
  Account? _userFromFirebase(User? user) {
    return user != null
        ? Account(uid: user.uid, firstName: user.displayName, inGroup: false)
        : null;
  }

  //create a AnonAccount obj based on firebase anon user
  // AnonAccount? _returnAnonUserFromFirebase(User? user) {
  //   return user != null ? AnonAccount(uid: user.uid) : null;
  // }
  Account? getCurrent() {
    User? user = FirebaseAuth.instance.currentUser;
    return _userFromFirebase(user!);
  }

  Stream<Account?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Stream<AnonAccount?> get anonUser {
  //   return _auth.authStateChanges().map(_returnAnonUserFromFirebase);
  // }
  Future UpdateAccount(
      String email, String name, String lastName, String age) async {
    try {
      //print("hi my name is");
      //print(_auth.currentUser!.email);

      var currentuser =
          await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
      var inGroup = currentuser.get('groupId');
     // print("first name is" + name);
      //print("last name is " + lastName);
      await DatabaseService(uid: _auth.currentUser!.uid)
          .updateUserData(name, lastName, age, inGroup, false, 0);
      return true;
    } catch (e) {
      //print(e.toString());
    }
  }

  Future updateEmail(String newEmail, String Password) async {
    String? email = _auth.currentUser!.email;
    if (email != null) {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: Password);
      _auth.currentUser!.updateEmail(newEmail);
      return true;
    }
  }

  Future updatePassword(String Password, String newPassword) async {
    String? email = _auth.currentUser!.email;
    if (email != null) {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: Password);
      _auth.currentUser!.updatePassword(newPassword);
      return true;
    }
  }

  Future CreateAccount(String email, String password, String name,
      String lastName, String age) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = credential.user;
      //Update information to cloud
      await DatabaseService(uid: credential.user!.uid)
          .updateUserData(name, lastName, age, '', false, 0);
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      //print(e.toString());
      return e.toString();
      //print(e.toString());
      return e.toString();
    }
  }

  Future LogInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = credential.user;
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  Future signInAnon(String nickname) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? firebaseUser = result.user;
      AnonAccount anonAccount = AnonAccount(
          uid: firebaseUser!.uid, inGroup: false, nickname: nickname);
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(nickname, null, '18', '', true, 0);
      //print('Check!' + firebaseUser.toString());
      return _userFromFirebase(firebaseUser);
    } catch (e) {
     // print(e.toString());
      return null;
    }
  }

  Future signOut(String groupUID) async {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.loading.value = false;
    });
    try {
      User? result = _auth.currentUser;
      var testUser = DatabaseService(uid: result!.uid);
      if (result.isAnonymous && groupUID != '') {
       // print("sign out anon in group");
        testUser.removeUserFromGroup(groupUID);
        testUser.deleteUser();
        return await _auth.signOut();
      } else if (result.isAnonymous) {
       // print("sign out anon not in group ");
        testUser.deleteUser();
        return await _auth.signOut();
      } else {
       // print("sign out3");
        return await _auth.signOut();
      }
    } catch (e) {
    //  print(e.toString());
      return null;
    }
  }

  Future<String?> getCurrentUserEmail() async {
    return await _auth.currentUser!.email;
  }

  Future<bool?> getCurrentUserStatus() async {
    return await _auth.currentUser!.isAnonymous;
  }

  Future<String?> getCurrentUserfirstName() async {
    var currentuser =
        await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
    return currentuser.get('Firstname');
  }

  Future<DocumentSnapshot<Object?>> getCurrentUser() async {
    return await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
  }

  Future<String?> getCurrentUserLastName() async {
    var currentuser =
        await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
    return currentuser.get('Surname');
  }

  Future<String?> getCurrentUserGroupId() async {
    var currentuser =
        await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
    return currentuser.get('groupId');
  }

  Future<String?> getCurrentUserAge() async {
    var currentuser =
        await DatabaseService(uid: _auth.currentUser!.uid).getcurrentUser();
    return currentuser.get('Age');

    //create a group
  }
}
