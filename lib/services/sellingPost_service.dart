import 'package:polyfam/models/selling_post.dart';
import 'package:polyfam/models/tweet_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyfam/services/auth_service.dart';

class SellingPostService {
  AuthService authService = AuthService();

  addSellingPost(item,location, phoneNumber, datePosted,imageUrl) {
    return FirebaseFirestore.instance.collection('sellingposts')
        .add({
      'email': authService.getCurrentUser()!.email,
      'item': item,
      'location': location,
      'phoneNumber': phoneNumber,
      'datePosted': datePosted,
      'imageUrl': imageUrl,

    });
  }

  removeSellingPost(id) {
    return FirebaseFirestore.instance.collection('sellingposts').doc(id).delete();
  }

  Stream<List<SellingPost>> getSellingPost() {
    return FirebaseFirestore.instance
        .collection('sellingposts')
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map<SellingPost>((doc) => SellingPost.fromMap(doc.data(), doc.id))
          .toList());
  }


}
