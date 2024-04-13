import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post(
      {required this.username,
      required this.caption,
      required this.uid,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImage,
      this.likes});

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'postId': postId,
        'username': username,
        'uid': uid,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return Post(
        username: snapshot['username'],
        caption: snapshot['caption'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        uid: snapshot['uid'],
        postUrl: snapshot['postUrl'],
        likes: snapshot['likes'],
        profileImage: snapshot['profileImage']);
  }
}
