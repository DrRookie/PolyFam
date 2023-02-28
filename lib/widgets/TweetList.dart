
import 'dart:ui';
import 'package:fluttericon/typicons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/models/profile_info.dart';
import 'package:polyfam/models/tweet_post.dart';
import 'package:polyfam/services/profileInfo_service.dart';
import 'package:polyfam/services/tweetPost_service.dart';
import 'package:provider/provider.dart';

import '../screens/editInteractionPost.dart';
import '../services/auth_service.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'AnekLatin-Regular'),
      home: TweetList(),
    );
  }
}




class TweetList extends StatefulWidget {
  @override
  State<TweetList> createState() => _TweetListState();
}


class _TweetListState extends State<TweetList> {
  TweetPostService fsTweetService = TweetPostService();
  ProfileInfoService fsProfileService = ProfileInfoService();

  AuthService authService = AuthService();



  void removeItem(String id) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                     fsTweetService.removeTweetPost(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

        return StreamBuilder<List<ProfileInformation>>(
          stream: fsProfileService.getProfileInfo(),
          builder: (context, snapshotProfile) {
          if (snapshotProfile.connectionState == ConnectionState.waiting)
           return Center(child: CircularProgressIndicator());
          else {
              Map<String, String>? emailUsername = {};
              snapshotProfile.data!.forEach((doc) {
              emailUsername.putIfAbsent(doc.id, () => doc.username);
    });
              Map<String, String>? others = {};
              snapshotProfile.data!.forEach((doc) {
                others.putIfAbsent(doc.id, () => doc.whatPoly);
              });

            return StreamBuilder<List<TweetPost>>(
              stream: fsTweetService.getTweetPost(),
              builder: (context, snapshotPost) {
                if (snapshotPost.connectionState == ConnectionState.waiting || snapshotProfile.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 50),
                    itemBuilder: (ctx, i) {
                      return Card(
                        color: Color(0xff9EA3B8),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                            onLongPress: () {
                              Navigator.of(context).pop();

                              snapshotPost.data![i].email == authService.getCurrentUser()!.email ? Navigator.of(context)
                                  .pushNamed(
                                  EditInteractionScreen.routeName, arguments: snapshotPost.data![i]): Center();
                            },
                            title: Row(
                              children: [
                                Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/user_2.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      shape: BoxShape.circle,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 50),
                                        child: Text(
                                            emailUsername[snapshotPost.data![i].email].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                      Text(
                                       "Student @"+others[snapshotPost.data![i].email].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10),
                                      ),

                                      Text(
                                        snapshotPost.data![i].postDate.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 30),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 150),
                                        child: Text(snapshotPost.data![i].tag),
                                      ),
                                      Image(
                                          image: NetworkImage(snapshotPost.data![i].imageUrl)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, top: 25),
                                  child: Text(
                                    snapshotPost.data![i].tweet,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () =>
                                  showDialog(
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 350, right: 25),
                                          child: AlertDialog(
                                            actionsAlignment: MainAxisAlignment.center,
                                            actions: [

                                              IconButton(
                                                iconSize: 30,
                                                icon: Icon(
                                                    Icons.perm_identity_outlined),
                                                onPressed: () {

                                                },
                                              ),

                                              IconButton(
                                                iconSize: 30,
                                                icon: Icon(Icons.chat_bubble_rounded),
                                                onPressed: () {

                                                },
                                              ),

                                              snapshotPost.data![i].email == authService.getCurrentUser()!.email ?
                                              IconButton(
                                                iconSize: 30,
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                  removeItem(snapshotPost.data![i].id);
                                                },
                                              ) : Center()

                                            ],
                                            elevation: 10,
                                            backgroundColor: Color(0xff9EA3C5),),
                                        );
                                      }, context: context
                                  ),
                            )),
                      );
                    },
                    itemCount: snapshotPost.data!.length ,
                    separatorBuilder: (ctx, i) {
                      return Divider(height: 10, color: Colors.transparent);
                    },
                  );
                }
              }
            );
            }
          }
        );


  }
}
