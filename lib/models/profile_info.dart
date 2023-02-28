class ProfileInformation {
  String id;
  String profilePicture;
  String fullName;
  String username;
  String email;
  String aboutMe;
  String hashtags;
  String whatPoly;





  ProfileInformation(
      {required this.id,required this.profilePicture,required this.fullName,required this.username, required this.email, required this.aboutMe,
        required this.hashtags, required this.whatPoly});

  ProfileInformation.fromMap(Map <String, dynamic>? snapshot, String id) :
        id = id,
        profilePicture = snapshot!['profilePicture'] ?? '',
        fullName = snapshot['fullName'] ?? '',
        username = snapshot['username'] ?? '',
        email = snapshot['email'] ?? '',
        aboutMe = snapshot['aboutMe'] ?? '',
        hashtags = snapshot['hashtags'] ?? '',
        whatPoly = snapshot['whatPoly'] ?? '';


}
