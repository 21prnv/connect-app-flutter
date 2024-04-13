import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String email;
  final String bio;
  final String username;
  final String uid;
  final String profileUrl;
  final List followers;
  final List following;

  const User(
      {required this.username,
      required this.bio,
      required this.email,
      required this.followers,
      required this.uid,
      required this.following,
      required this.profileUrl});

  Map<String, dynamic> toJson() => {
        'email': email,
        'bio': bio,
        'username': username,
        'uid': uid,
        'profileUrl': profileUrl,
        'followers': [],
        'following': [],
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return User(
        username: snapshot['username'],
        bio: snapshot['bio'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        uid: snapshot['uid'],
        following: snapshot['following'],
        profileUrl: snapshot['profileUrl']);
  }
}
