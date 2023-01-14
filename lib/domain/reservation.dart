//予約情報クラス

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  //todo: startTimeよりendTimeが早ければコンストラクタでエラーを出す
  Reservation(
      {required this.startTime,
      required this.finishTime,
      required this.targetMember,
      required this.treatmentDetailList,
      required this.treatmentDetail,
      required this.reservationId,
      this.beforePrice,
      required this.afterPrice,
      required this.menuIntroduction,
      required this.menuImageUrl,
      required this.menuId,
      required this.treatmentTime,
      required this.name,
      required this.dateOfBirth,
      required this.telephoneNumber,
      required this.gender,
      required this.uid});

  Timestamp startTime;
  Timestamp finishTime;
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
  String name;
  String dateOfBirth;
  String telephoneNumber;
  String gender;
  String uid;

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
    );
  }
}

//
// いつもお世話になっております。
// 大変恐縮ではございますが、４講は既に満席となっております。
// 申し訳ございません。
//
// お手数ではございますが、再度ご検討の上、ご連絡いただければと思いますので、よろしくお願いいたします。
