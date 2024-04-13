import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:connect_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfleScreen extends StatefulWidget {
  final String uid;
  const ProfleScreen({super.key, required this.uid});

  @override
  State<ProfleScreen> createState() => _ProfleScreenState();
}

class _ProfleScreenState extends State<ProfleScreen> {
  var userData = {};
  int postLenth = 0;
  bool isFetching = false;
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
      setState(() {
        isFetching = true;
      });
      var userDataSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userDataSnap.data()!;
      var postsLen = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLenth = postsLen.docs.length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isFetching = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isFetching
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 9,
                            ),
                            Text(
                              userData['username'],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.black,
                                  )),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                )),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userData['profileUrl']),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                Text(
                                  postLenth.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text('Posts'),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  userData['followers'].length.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text('Followers'),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  userData['following'].length.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text('Following'),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Text(
                      userData['username'],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userData['bio'],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 55),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(88, 158, 158, 158),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 55),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(88, 158, 158, 158),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: const Text(
                                  'Share Profile',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : isFollowing
                            ? InkWell(
                                onTap: () async {
                                  await FireStoreMethods().following(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    userData['followers'].length--;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(88, 158, 158, 158),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3))),
                                  child: const Text(
                                    'Following',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  await FireStoreMethods().following(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    userData['followers'].length++;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3))),
                                  child: const Text(
                                    'Follow',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey,
                      ))),
                      child: const Icon(Icons.grid_on_outlined),
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
