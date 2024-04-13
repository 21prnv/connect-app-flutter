import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/model/user.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:connect_app/widgets/comment_card.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.user, required this.snap});
  final User user;
  final snap;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Container(
                height: 8,
                width: 35,
                margin: const EdgeInsets.only(bottom: 8, top: 14),
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 2)),
                    borderRadius: BorderRadius.all(Radius.circular(14))),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                        user: widget.user,
                        snap: (snapshot.data! as dynamic).docs[index].data());
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 18, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profileUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Comment as ${widget.user.username}..'),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    await FireStoreMethods().commentOnPost(
                        widget.snap['postId'],
                        commentController.text,
                        widget.user.username,
                        widget.user.uid,
                        widget.user.profileUrl);
                    commentController.clear();
                  },
                  child: Text('Post'))
            ],
          ),
        ),
      ),
    );
  }
}
