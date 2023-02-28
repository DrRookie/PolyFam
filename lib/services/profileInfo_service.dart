import 'package:polyfam/models/profile_info.dart';
import 'package:polyfam/models/tweet_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyfam/services/auth_service.dart';

class ProfileInfoService {
  AuthService authService = AuthService();

  addProfile(imageUrl,fullName, username, email, whatPoly) {
    return FirebaseFirestore.instance.collection('users').doc(email)
        .set({
      'email': email,
      'profilePicture':imageUrl,
      'fullName': fullName,
      'username': username,
      'whatPoly': whatPoly,

    });
  }

  removeAccount(id) {
    return FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  Stream<List<ProfileInformation>> getProfileInfo() {
    return FirebaseFirestore.instance
        .collection('users')
        //.where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map<ProfileInformation>((doc) => ProfileInformation.fromMap(doc.data(), doc.id))
        .toList());
  }

  editProfile(id, aboutMe, hashtags) {
    return FirebaseFirestore.instance.collection('users').doc(id)
    .set({
      'aboutMe': aboutMe,
      'hashtags': hashtags,
    });
  }




}
