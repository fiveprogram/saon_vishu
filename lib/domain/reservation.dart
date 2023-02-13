//予約情報クラス

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  Reservation(
      {required this.startTime,
      required this.finishTime,
      required this.targetMember,
      required this.treatmentDetailList,
      required this.treatmentDetail,
      required this.reservationId,
      this.beforePrice,
      this.lastVisit,
      required this.afterPrice,
      required this.menuIntroduction,
      required this.menuImageUrl,
      required this.menuId,
      required this.treatmentTime,
      required this.name,
      required this.dateOfBirth,
      required this.telephoneNumber,
      required this.isNeedExtraMoney,
      required this.gender,
      required this.uid,
      required this.priority,
      required this.deviceIdList,
      required this.userImage});

  Timestamp startTime;
  Timestamp finishTime;
  Timestamp? lastVisit;
  String targetMember;
  List<dynamic> treatmentDetailList;
  String treatmentDetail;
  int? beforePrice;
  int afterPrice;
  String menuIntroduction;
  String menuImageUrl;
  String menuId;
  String? reservationId;
  int treatmentTime;
  int? priority;
  bool isNeedExtraMoney;
  String name;
  String dateOfBirth;
  String telephoneNumber;
  String gender;
  String uid;
  String? userImage;
  List<dynamic> deviceIdList;

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        startTime: data['startTime'],
        finishTime: data['finishTime'],
        targetMember: data['targetMember'],
        treatmentDetailList: data['treatmentDetailList'],
        beforePrice: data['beforePrice'],
        afterPrice: data['afterPrice'],
        menuIntroduction: data['menuIntroduction'],
        menuImageUrl: data['menuImageUrl'],
        menuId: data['menuId'],
        reservationId: data['reservationId'],
        treatmentTime: data['treatmentTime'],
        treatmentDetail: data['treatmentDetail'],
        name: data['name'],
        dateOfBirth: data['dateOfBirth'],
        telephoneNumber: data['telephoneNumber'],
        gender: data['gender'],
        uid: data['uid'],
        priority: data['priority'],
        isNeedExtraMoney: data['isNeedExtraMoney'],
        lastVisit: data['lastVisit'],
        deviceIdList: data['deviceIdList'],
        userImage: data['userImage']);
  }
}
