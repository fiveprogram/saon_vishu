//予約情報クラス

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  //todo: startTimeよりendTimeが早ければコンストラクタでエラーを出す
  const Reservation(this.startTime, this.finishTime, this.menuId, this.uid);
  //施術の開始時間
  final Timestamp startTime;
  //施術の終了時間
  final Timestamp finishTime;
  //施術のメニュー
  final String menuId;
  //予約者のID
  final String uid;

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        data['startTime'], data['finishTime'], data['menuId'], data['uid']);
  }
}
