import 'package:cloud_firestore/cloud_firestore.dart';

class Version {
  String? iosMinAvailableVersion;
  String? androidMinAvailableVersion;

  Version({
    required this.iosMinAvailableVersion,
    required this.androidMinAvailableVersion,
  });

  factory Version.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Version(
        iosMinAvailableVersion: data['iosMinAvailableVersion'],
        androidMinAvailableVersion: data['androidMinAvailableVersion']);
  }
}
