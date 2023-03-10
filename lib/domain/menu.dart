import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String? targetMember;
  List<dynamic> treatmentDetailList;
  String treatmentDetail;
  int? beforePrice;
  int afterPrice;
  String menuIntroduction;
  String? menuImageUrl;
  String? menuId;
  int treatmentTime;
  int? priority;
  bool isNeedExtraMoney;
  bool isCallable;

  Menu({
    this.targetMember,
    required this.treatmentDetailList,
    required this.treatmentDetail,
    this.beforePrice,
    required this.afterPrice,
    required this.menuIntroduction,
    this.menuImageUrl,
    this.menuId,
    required this.treatmentTime,
    this.priority,
    required this.isNeedExtraMoney,
    required this.isCallable,
  });

  factory Menu.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Menu(
      targetMember: data['targetMember'],
      treatmentDetailList: data['treatmentDetailList'],
      treatmentDetail: data['treatmentDetail'],
      beforePrice: data['beforePrice'],
      afterPrice: data['afterPrice'],
      menuIntroduction: data['menuIntroduction'],
      menuImageUrl: data['menuImageUrl'],
      menuId: data['menuId'],
      treatmentTime: data['treatmentTime'],
      priority: data['priority'],
      isNeedExtraMoney: data['isNeedExtraMoney'],
      isCallable: data['isCallable'] ?? false,
    );
  }
}
