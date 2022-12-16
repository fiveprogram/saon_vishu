import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  bool isTargetAllMember = true;
  List<String> treatmentDetailList;
  String treatmentDetail;
  String beforePrice;
  String afterPrice;
  String menuIntroduction;
  String menuImageUrl;

  Menu(
      {required this.isTargetAllMember,
      required this.treatmentDetailList,
      required this.treatmentDetail,
      required this.beforePrice,
      required this.afterPrice,
      required this.menuIntroduction,
      required this.menuImageUrl});

  factory Menu.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Menu(
        isTargetAllMember: data['isTargetAllMember'],
        treatmentDetailList: data['treatmentDetailList'],
        treatmentDetail: data['treatmentDetail'],
        beforePrice: data['beforePrice'],
        afterPrice: data['afterPrice'],
        menuIntroduction: data['menuIntroduction'],
        menuImageUrl: data['menuImageUrl']);
  }
}
