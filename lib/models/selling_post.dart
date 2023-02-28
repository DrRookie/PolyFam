import 'package:cloud_firestore/cloud_firestore.dart';

class SellingPost {
  String id;
  String email;
  String item;
  String location;
  String phoneNumber;
  DateTime? datePosted;
  String imageUrl;


  SellingPost(
      {required this.id, required this.email, required this.item,required this.location, required this.phoneNumber,
        required this.datePosted, required this.imageUrl
      });



  SellingPost.fromMap(Map <String, dynamic> snapshot, String id) :
        id = id,
        email = snapshot['email'] ?? '',
        item = snapshot['item'] ?? '',
        location = snapshot['location'] ?? '',
        phoneNumber = snapshot['phoneNumber'] ?? '',
        datePosted = (snapshot['datePosted'] ?? Timestamp.now()).toDate(),
        imageUrl = snapshot['imageUrl'] ?? '';

}
