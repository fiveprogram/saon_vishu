import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salon_vishu/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/profile.dart';
import '../domain/version.dart';
import '../firebase_options.dart';

class ProfileModel extends ChangeNotifier {
  Profile? profile;
  Version? version;

  Future<void> fetchVersion() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> versionStream =
        FirebaseFirestore.instance
            .collection('force_update')
            .doc('uHoECUdMBarAX1H61FTC')
            .snapshots();

    versionStream.listen((snapshot) {
      version = Version.fromFirestore(snapshot);
      notifyListeners();
    });
  }

  Future<void> fetchProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    final profileStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots();

    profileStream.listen((snapshot) {
      profile = Profile.fromFirestore(snapshot);
      notifyListeners();
    });
  }

  Future<void> googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await showDialog(
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
                  onPressed: () async {
                    await googleSignOut();
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false);
                  }),
            ],
          );
        });
  }

  Future<void> urlTermOfService() async {
    final Uri termOfServiceUrl = Uri.parse(
        'https://abalone-lemongrass-524.notion.site/0dbff2a0a09848afa32698c7945fad30');

    if (await canLaunchUrl(termOfServiceUrl)) {
      await launchUrl(termOfServiceUrl);
    } else {
      throw '$termOfServiceUrl';
    }
  }

  Future<void> policyUrl() async {
    final Uri urlPolicy = Uri.parse(
        'https://abalone-lemongrass-524.notion.site/3d1520fb1d294916ac30ae784a56c6fb');

    if (await canLaunchUrl(urlPolicy)) {
      await launchUrl(urlPolicy);
    } else {
      throw '$urlPolicy';
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('本当にアカウントを削除してもよろしいですか？'),
            content: const Text('削除後データの復元はできません'),
            actions: [
              CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('削除する'),
                  onPressed: () async {
                    await FirebaseFunctions.instance
                        .httpsCallable('authDelete')
                        .call();

                    await googleSignOut();
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false);
                    // await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .doc(user!.uid)
                    //     .delete();
                    //
                    // await FirebaseAuth.instance.signOut();
                  }),
            ],
          );
        });
  }
}
