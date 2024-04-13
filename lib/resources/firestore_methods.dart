import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/model/post.dart';
import 'package:connect_app/resources/storage_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'Something went wrong';
    try {
      String photoUrl =
          await StorageMethod().ulpoadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
          username: username,
          caption: caption,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);
      firebaseFirestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likedPost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> commentOnPost(String postId, String text, String name,
      String uid, String profileUrl) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'postId': postId,
          'commentId': commentId,
          'text': text,
          'name': name,
          'uid': uid,
          'profileUrl': profileUrl,
          'datePublished': DateTime.now(),
          'likes': []
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> likedComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> following(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firebaseFirestore.collection('users').doc(uid).get();

      List followList = (snap.data()! as dynamic)['following'];

      if (followList.contains(followId)) {
        await firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<String> getCurrentUserName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print(data['username']);
    return data['username'];
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatRooms(String myUserName) async {
    // String? myUsername = await SharedPreferenceHelper().getUserName();
    // print(myUsername);
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUserName)
        .snapshots();
  }
}
