import 'package:connect_app/screens/add_post_screen.dart';
import 'package:connect_app/screens/feed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('data1'),
  ProfleScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
