import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceTokenId {
  String? iosDeviceId;
  String? androidDeviceId;

  DeviceTokenId({required this.iosDeviceId, required this.androidDeviceId});

  factory DeviceTokenId.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DeviceTokenId(
        iosDeviceId: data['iosDeviceId'],
        androidDeviceId: data['androidDeviceId']);
  }
}
