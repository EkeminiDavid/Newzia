import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/bottom_nav_bar.dart';
import 'package:newzia/helpers/news_tile.dart';
import 'package:newzia/screens/custom_display.dart';

import 'package:newzia/screens/second_onboarding_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

User? loggedInUser;
final String? currentUser = loggedInUser?.email;

class BookmarkScreen extends StatefulWidget {
  static const id = 'bookmark screen';

  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Bookmarks',
              style: TextStyle(
                  color: kNewziaBlue,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.popUntil(context,
                            (ModalRoute.withName(SecondOnboardingScreen.id)));
                      });
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                    }
                  },
                  icon: const Icon(Icons.lock_outline_rounded))
            ]),
        bottomNavigationBar: const BottomNavBar(
          index: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookmarks')
                  .where('user', isEqualTo: currentUser)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const CustomNotificationDisplay(
                      text: 'Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomNotificationDisplay(text: 'Loading...');
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final bookmark = snapshot.data!.docs[index];

                        return NewsTile(
                          articleSource: bookmark['article source'],
                          articleTitle: bookmark['article title'],
                          articleUrl: bookmark['url to article'],
                          imageUrl: bookmark['url to image'],
                          isBookmarked: true,
                          publishAt: bookmark['published time'],
                          onPressed: () async {
                            try {
                              await bookmark.reference.delete().then((value) {
                                Fluttertoast.showToast(
                                  msg: "Item deleted from bookmark",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kNewziaBlue,
                                  textColor: kNewziaBackgroundWhite,
                                  fontSize: 16.0,
                                );
                              });
                            } on FirebaseException catch (e) {
                              print(e.code);
                              Fluttertoast.showToast(
                                msg: "Error in deleting item from bookmark",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kNewziaBlue,
                                textColor: kNewziaBackgroundWhite,
                                fontSize: 16.0,
                              );
                            }
                          },
                        );
                      });
                } else {
                  return const CustomNotificationDisplay(
                    text: 'No bookmarks yet!!!',
                  );
                }
              }),
        ));
  }
}
