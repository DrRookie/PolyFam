import 'package:polyfam/models/tweet_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyfam/services/auth_service.dart';

class TweetPostService {
  AuthService authService = AuthService();

  addTweetPost(imageUrl,postDate, tweet, tag) {
    return FirebaseFirestore.instance.collection('tweetposts')
        .add({
      'imageUrl': imageUrl,
      'email': authService.getCurrentUser()!.email,
      'postDate': postDate,
      'tweet': tweet,
      'tag': tag,

    });
  }

  removeTweetPost(id) {
    return FirebaseFirestore.instance.collection('tweetposts').doc(id).delete();
  }

  Stream<List<TweetPost>> getTweetPost() {
    return FirebaseFirestore.instance
        .collection('tweetposts')
        //.where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<TweetPost>((doc) => TweetPost.fromMap(doc.data(), doc.id))
            .toList());
  }

  editTweetPost(id, tweet, tag, postDate) {
    return FirebaseFirestore.instance.collection('tweetposts').doc(id).update({
      'tweet': tweet,
      'tag': tag,
      'postDate': postDate,
    });
  }
}
