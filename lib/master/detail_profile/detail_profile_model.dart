import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_vishu/domain/profile.dart';

class DetailProfileModel extends ChangeNotifier {
  String uid;
  DetailProfileModel(this.uid);

  Profile? profile;

  Future<void> fetchProfile() async {
    final profileStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    profileStream.listen((snapshot) {
      profile = Profile.fromFirestore(snapshot);
      notifyListeners();
    });
  }
}
