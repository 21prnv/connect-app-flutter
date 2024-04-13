import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/model/user.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.snap, required this.user});
  final snap;
  final User user;
  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String formatTimestamp() {
    Timestamp time = widget.snap['datePublished'];

    Duration duration = Duration(seconds: time.seconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String formattedTime = '';

    if (hours > 0) {
      formattedTime = '${hours}h';
    }
    if (minutes > 0) {
      formattedTime = '${minutes}m';
    }
    if (seconds > 0) {
      formattedTime = '${seconds}s';
    }

    return formattedTime.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileUrl']),
                  radius: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.snap['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          formatTimestamp(),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        widget.snap['text'],
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await FireStoreMethods().likedComment(
                                              widget.snap['postId'],
                                              widget.snap['commentId'],
                                              widget.user.uid,
                                              widget.snap['likes']);
                                        },
                                        icon: Column(
                                          children: [
                                            const Icon(
                                              Icons.favorite_border,
                                              size: 15,
                                            ),
                                            Text(
                                                '${widget.snap['likes'].length}'),
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
