import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String email;
  String name;
  String dateOfBirth;
  String telephoneNumber;
  String uid;
  String imgUrl;
  String gender;
  Timestamp dateTime;
  Timestamp? lastVisit;

  Profile(
      {required this.email,
      required this.name,
      required this.dateOfBirth,
      required this.telephoneNumber,
      required this.uid,
      required this.imgUrl,
      required this.gender,
      required this.dateTime,
      required this.lastVisit});

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profile(
        email: data['email'],
        name: data['name'],
        dateOfBirth: data['dateOfBirth'],
        telephoneNumber: data['telephoneNumber'],
        uid: data['uid'],
        imgUrl: data['imgUrl'],
        gender: data['gender'],
        dateTime: data['dateTime'],
        lastVisit: data['lastVisit']);
  }
}
