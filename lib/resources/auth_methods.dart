import 'dart:ffi';
import 'dart:typed_data';
import 'package:connect_app/model/user.dart' as model;
import 'package:connect_app/resources/storage_method.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String? res = 'Something went wrong';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential.user!.uid);

        String profileUrl = await StorageMethod()
            .ulpoadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            bio: bio,
            email: email,
            followers: [],
            uid: userCredential.user!.uid,
            following: [],
            profileUrl: profileUrl);

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      res = err.message;
    }
    return res!;
  }

  //Log in the user

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Something went wrong';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'please enter all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
