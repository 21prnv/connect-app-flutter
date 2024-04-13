import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/model/user.dart';
import 'package:connect_app/resources/auth_methods.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:connect_app/screens/comment_screen.dart';
import 'package:connect_app/widgets/FrostedGlassBox.dart';
import 'package:connect_app/widgets/likes_animation.dart';
import 'package:connect_app/widgets/skeleton_post_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap, required this.user});
  final snap;
  final User user;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    Timestamp time = widget.snap['datePublished'];
    String hours = DateFormat('HH').format(time.toDate());
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: FrostedGlassBox(
        theWidth: double.infinity,
        theHeight: 600,
        theChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(widget.snap['profileImage']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          widget.snap['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FireStoreMethods().likedPost(widget.snap['postId'],
                    widget.user.uid, widget.snap['likes']);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimation: isLikeAnimating,
                      duration: const Duration(milliseconds: 300),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeAnimation(
                          isAnimation:
                              widget.snap['likes'].contains(widget.user.uid),
                          smallLIke: true,
                          child: IconButton(
                              onPressed: () async {
                                await FireStoreMethods().likedPost(
                                    widget.snap['postId'],
                                    widget.user.uid,
                                    widget.snap['likes']);
                                setState(() {
                                  isLikeAnimating = true;
                                });
                              },
                              icon:
                                  widget.snap['likes'].contains(widget.user.uid)
                                      ? const Icon(
                                          Icons.favorite_border,
                                          size: 30,
                                        )
                                      : const Icon(Icons.favorite_border))),
                      IconButton(
                          onPressed: () {
                            showBottomSheet(
                              elevation: 30,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return CommentScreen(
                                  user: widget.user,
                                  snap: widget.snap,
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.chat_bubble_outline_outlined,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.telegram_rounded,
                            size: 30,
                          ))
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: ['Delete']
                                        .map((e) => InkWell(
                                              onTap: () async {
                                                await FireStoreMethods()
                                                    .deletePost(
                                                        widget.snap['postId']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Icons.bookmark_border_outlined,
                        size: 30,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('${widget.snap['likes'].length} likes'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text(
                    widget.snap['username'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(widget.snap['caption']),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 5),
                child: Text(
                  'view all 200 comments',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 5),
              child: Text(
                '$hours hours ago',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
