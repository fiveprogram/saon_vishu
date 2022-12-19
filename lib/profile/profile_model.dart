import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salon_vishu/domain/profile.dart';

class ProfileModel extends ChangeNotifier {
  Profile? profile;

  Future<void> fetchProfile() async {
    Stream<QuerySnapshot> profileStream =
        FirebaseFirestore.instance.collection('users').limit(1).snapshots();

    profileStream.listen((snapshot) {
      profile = Profile.fromFirestore(snapshot.docs[0]);
      notifyListeners();
    });
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('本当にログアウトしますか？'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
