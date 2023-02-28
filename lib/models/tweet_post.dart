

import 'package:cloud_firestore/cloud_firestore.dart';

class TweetPost {
  String email;
  String id;
  String tweet;
  String tag;
  DateTime? postDate;
  String imageUrl;


  TweetPost({required this.id,required this.imageUrl,required this.email, required this.postDate,required this.tweet, required this.tag});

  TweetPost.fromMap(Map <String, dynamic> snapshot, String id) :
        id = id,
        imageUrl = snapshot['imageUrl'] ?? '',
        email = snapshot['email'] ?? '',
        postDate = (snapshot['postDate'] ?? Timestamp.now()).toDate(),
        tweet = snapshot['tweet'] ?? '',
        tag = snapshot['tag'] ?? '';





}
