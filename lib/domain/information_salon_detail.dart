import 'package:cloud_firestore/cloud_firestore.dart';

class InformationSalonDetail {
  List<dynamic> vishuImagesList = [];
  //サロンから一言の画像
  String vishuImage;
  //オーナーのれき
  String skillYear;
  //オーナーの一言
  String ownerWord;
  //オーナー写真
  String stylistImage;

  String infoId;

  InformationSalonDetail(
      {required this.vishuImagesList,
      required this.vishuImage,
      required this.skillYear,
      required this.ownerWord,
      required this.stylistImage,
      required this.infoId});

  factory InformationSalonDetail.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InformationSalonDetail(
        vishuImagesList: data['vishuImagesList'],
        vishuImage: data['vishuImage'],
        stylistImage: data['stylistImage'],
        ownerWord: data['ownerWord'],
        skillYear: data['skillYear'],
        infoId: data['infoId']);
  }
}

///後から更新できるのが、スタイリストの写真・名前・経歴・一言
///ページ上部の写真・vishuの写真は後から更新することができる。
