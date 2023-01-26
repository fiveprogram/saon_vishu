import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceTokenId {
  String? deviceId;

  DeviceTokenId({required this.deviceId});

  factory DeviceTokenId.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DeviceTokenId(deviceId: data['deviceId']);
  }
}
