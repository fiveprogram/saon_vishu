import 'package:cloud_firestore/cloud_firestore.dart';

class Rest {
  const Rest(this.startTime, this.endTime);

  //休憩開始時刻
  final Timestamp startTime;
  //休憩終了時刻
  final Timestamp endTime;

  factory Rest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Rest(data['startTime'], data['endTime']);
  }
}
