import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:connect_app/screens/chat_screen.dart';
import 'package:connect_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MessagesScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  String getChatRoomIdbyUsername(String a, String b) {
    List<String> userNames = [a, b];
    userNames.sort();
    return "${userNames[0]}_${userNames[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Messages',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isNotEqualTo: uid)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          String currentUserName =
                              await FireStoreMethods().getCurrentUserName();

                          var chatRoomId = getChatRoomIdbyUsername(
                              currentUserName,
                              (snapshot.data! as dynamic).docs[index]
                                  ['username']);
                          Map<String, dynamic> chatRoomInfoMap = {
                            "users": [
                              currentUserName,
                              (snapshot.data! as dynamic).docs[index]
                                  ['username']
                            ],
                          };
                          await FireStoreMethods()
                              .createChatRoom(chatRoomId, chatRoomInfoMap);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatRoomId: chatRoomId,
                              name: (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                              profileurl: (snapshot.data! as dynamic)
                                  .docs[index]['profileUrl'],
                              currentusername: currentUserName,
                            ),
                          ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['profileUrl']),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
