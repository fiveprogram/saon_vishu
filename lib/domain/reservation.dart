//予約情報クラス
import 'package:salon_vishu/domain/menu.dart';

class Reservation {
  //todo: startTimeよりendTimeが早ければコンストラクタでエラーを出す
  const Reservation(this.startTime, this.finishTime, this.menu, this.uid);
  //施術の開始時間
  final DateTime startTime;
  //施術の終了時間
  final DateTime finishTime;
  //施術のメニュー
  final Menu menu; //予約者のID

  final String uid;
}
