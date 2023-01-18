// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_6T-fkpYBs0oblu1rlP6-rEbSWdTkhA8',
    appId: '1:689319200957:android:4398fc9c1ff504566a4fd4',
    messagingSenderId: '689319200957',
    projectId: 'salon-vishu',
    storageBucket: 'salon-vishu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_iY2RXbkEgCAmhYcTzAk1Qdz4sI_0W1Y',
    appId: '1:689319200957:ios:ef659cc84846feae6a4fd4',
    messagingSenderId: '689319200957',
    projectId: 'salon-vishu',
    storageBucket: 'salon-vishu.appspot.com',
    androidClientId: '689319200957-fc1mu70j5gehhj42c2iajpgu3s0qhb3i.apps.googleusercontent.com',
    iosClientId: '689319200957-o9gmfknculnag70vmgqgmnha6lhhjv7q.apps.googleusercontent.com',
    iosBundleId: 'com.itsukage.salonVishu',
  );
}
