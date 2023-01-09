import 'package:cloud_firestore/cloud_firestore.dart';

class Rest {
  Rest(this.startTime, this.endTime, this.restId);

  //休憩開始時刻
  final Timestamp startTime;
  //休憩終了時刻
  final Timestamp endTime;

  String restId;

  factory Rest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Rest(data['startTime'], data['endTime'], data['restId']);
  }
}
