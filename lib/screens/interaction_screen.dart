import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:polyfam/models/tweet_post.dart';
import 'package:polyfam/screens/addInteractionPost.dart';
import 'package:polyfam/screens/profile_screen.dart';
import 'package:polyfam/services/tweetPost_service.dart';
import 'package:provider/provider.dart';

import 'package:polyfam/services/sellingPost_service.dart';
import 'package:polyfam/models/selling_post.dart';
import '../widgets/MainAppBar_widget.dart';
import '../widgets/SellingList.dart';
import '../widgets/TweetList.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'addSellingPost.dart';

class InteractionScreen extends StatefulWidget {
  static String routeName = '/interactionscreen';

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  int selectedIndex = 0;

  // @override
  @override
  Widget build(BuildContext context) {
    TweetPostService fsTweetService = TweetPostService();
    SellingPostService fsSellingService = SellingPostService();

    return StreamBuilder<List<TweetPost>>(
        stream: fsTweetService.getTweetPost(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator()) :
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshotGoogleSignin) {
                return StreamBuilder<List<SellingPost>>(
                  stream: fsSellingService.getSellingPost(),
                  builder: (context, snapshotSelling) {
                    return snapshot.connectionState == ConnectionState.waiting ?
                    Center(child: CircularProgressIndicator()) :
                     Scaffold(
                          resizeToAvoidBottomInset: false,
                          bottomNavigationBar: Container(
                            color: Color(0xFF272D39),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8),
                              child: GNav(
                                tabBackgroundColor: Colors.grey,
                                backgroundColor: Color(0xFF272D39),
                                color: Color(0xFF505F9D),
                                activeColor: Color(0xFF008A5C),
                                gap: 10,
                                haptic: true,
                                padding: EdgeInsets.all(16),
                                selectedIndex: selectedIndex,
                                onTabChange: (index) {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                tabs: [
                                  GButton(
                                    icon: Icons.home,
                                    text: 'Interaction',
                                    iconSize: 25,
                                  ),
                                  GButton(
                                    icon: Icons.shopify,
                                    text: 'Marketplace',
                                    iconSize: 25,
                                  ),
                                  GButton(
                                    icon: Icons.add_rounded,
                                    text: 'Interaction',
                                    iconSize: 25,
                                  ),
                                  GButton(
                                    icon: Icons.add_rounded,
                                    text: 'Selling',
                                    iconSize: 25,
                                  ),
                                  GButton(
                                    icon: Icons.person,
                                    text: 'Profile',
                                    iconSize: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: const Color(0xFF3B456E),
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(85.0),
                            child: MainAppBar(),
                          ),
                          body: Container(
                            child: selectedIndex == 0
                                ? snapshot.data!.isNotEmpty
                                    ? snapshot.connectionState == ConnectionState.waiting ?
                            Center(child: CircularProgressIndicator()) : TweetList()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 240, left: 60),
                                        child: Text('No tweets yet! Create one NOW!',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'AnekLatin',
                                                color: Colors.green)),
                                      )
                                : selectedIndex == 1 ?
                            snapshotSelling.data!.isNotEmpty
                                ? snapshotSelling.connectionState == ConnectionState.waiting ?
                            Center(child: CircularProgressIndicator()) : SellingList()
                                : Padding(
                              padding:
                              const EdgeInsets.only(top: 240, left: 60),
                              child: Text('No tweets yet! Create one NOW!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'AnekLatin',
                                      color: Colors.green)),
                            )
                                :selectedIndex == 2 ?
                                AddInteractionScreen():
                                selectedIndex == 3 ?
                                    AddSellingScreen():
                                    ProfileScreen()



                          ));
                  }
                );
              }
            );
        });
  }
}
