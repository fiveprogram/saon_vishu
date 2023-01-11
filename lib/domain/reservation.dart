//予約情報クラス

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  //todo: startTimeよりendTimeが早ければコンストラクタでエラーを出す
  Reservation(
      {required this.startTime,
      required this.finishTime,
      required this.isTargetAllMember,
      required this.treatmentDetailList,
      required this.treatmentDetail,
      this.beforePrice,
      required this.afterPrice,
      required this.menuIntroduction,
      required this.menuImageUrl,
      required this.menuId,
      required this.treatmentTime,
      required this.uid});

  Timestamp startTime;
  Timestamp finishTime;
  bool isTargetAllMember = true;
  List<dynamic> treatmentDetailList;
  String treatmentDetail;
  String? beforePrice;
  String afterPrice;
  String menuIntroduction;
  String menuImageUrl;
  String menuId;
  int treatmentTime;
  String uid;

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
      startTime: data['startTime'],
      finishTime: data['finishTime'],
      isTargetAllMember: data['isTargetAllMember'],
      treatmentDetailList: data['treatmentDetailList'],
      beforePrice: data['beforePrice'],
      afterPrice: data['afterPrice'],
      menuIntroduction: data['menuIntroduction'],
      menuImageUrl: data['menuImageUrl'],
      menuId: data['menuId'],
      treatmentTime: data['treatmentTime'],
      treatmentDetail: data['treatmentDetail'],
      uid: data['uid'],
    );
  }
}
