import 'package:firebase_auth/firebase_auth.dart';
import 'package:polyfam/models/profile_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AuthService {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> forgotPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Stream<ProfileInformation> getAuthUserFromFirestore(currentUserEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .snapshots()
        .map<ProfileInformation>(
            (doc) => ProfileInformation.fromMap(doc.data(), doc.id));
  }

  logOut() {
    return FirebaseAuth.instance.signOut();
  }
}
