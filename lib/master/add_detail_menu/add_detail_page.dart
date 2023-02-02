import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/menu.dart';
import 'package:salon_vishu/master/add_detail_menu/add_detail_model.dart';

// ignore: must_be_immutable
class AddDetailPage extends StatefulWidget {
  Menu? menu;
  AddDetailPage({this.menu, Key? key}) : super(key: key);

  @override
  State<AddDetailPage> createState() => _AddDetailPageState();
}

class _AddDetailPageState extends State<AddDetailPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => AddDetailModel(widget.menu),
      child: Consumer<AddDetailModel>(builder: (context, model, child) {
        return Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                return model.willPopCallback(context);
              },
              child: Scaffold(
                backgroundColor: HexColor('#fcf8f6'),
                appBar: vishuAppBar(appBarTitle: 'メニュー編集', isJapanese: true),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        if (model.file != null)
                          Container(
                            height: height * 0.15,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black87),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(model.file!),
                              ),
                            ),
                          ),
                        if (model.file == null && model.imgUrl == null)
                          Container(
                            height: height * 0.15,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://img.anikore.jp/images/profile/0/0/0//.jpg?width=72&height=72&type=crop'),
                                )),
                          ),
                        if (model.file == null && model.imgUrl != null)
                          Container(
                            height: height * 0.15,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(model.imgUrl!),
                                )),
                          ),
                        TextButton(
                            onPressed: () {
                              model.registerAccountPhoto(context);
                            },
                            child: const Text(
                              'メニューの写真を選択',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                        const Divider(),
                        const Text('・対象者',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Radio(
                                value: '全員',
                                groupValue: model.targetMember,
                                onChanged: (value) {
                                  setState(() {
                                    model.targetMember = value;
                                  });
                                }),
                            const Text(
                              '全員',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            SizedBox(width: width * 0.1),
                            Radio(
                                value: '新規',
                                groupValue: model.targetMember,
                                onChanged: (value) {
                                  setState(() {
                                    model.targetMember = value;
                                  });
                                }),
                            const Text(
                              '新規',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            SizedBox(width: width * 0.1),
                            Radio(
                                value: '再来',
                                groupValue: model.targetMember,
                                onChanged: (value) {
                                  setState(() {
                                    model.targetMember = value;
                                  });
                                }),
                            const Text(
                              '再来',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                        Divider(
                          height: height * 0.05,
                        ),
                        const Text('・施術内容',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: height * 0.02),
                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: model.treatmentTypeList.map((type) {
                            final isSelected =
                                model.selectedTypeList.contains(type);
                            return InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32)),
                              onTap: () {
                                if (isSelected) {
                                  // すでに選択されていれば取り除く
                                  model.selectedTypeList.remove(type);
                                } else {
                                  // 選択されていなければ追加する
                                  model.selectedTypeList.add(type);
                                }
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                  border: Border.all(
                                    width: 2,
                                    color: HexColor('#8f948a'),
                                  ),
                                  color:
                                      isSelected ? HexColor('#989593') : null,
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black87
                                        : HexColor('#8f948a'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Divider(
                          height: height * 0.05,
                        ),
                        const Text('・メニュー名',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLines: null,
                          maxLength: 100,
                          controller: model.treatmentDetailController,
                          decoration: const InputDecoration(
                              hintText: '（例）♪親子カット♪小学生まで☆¥5500',
                              border: OutlineInputBorder()),
                        ),
                        Divider(
                          height: height * 0.05,
                        ),
                        const Text('・料金(割引なしの場合、割引後価格のみ)',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            const Icon(Icons.currency_yen),
                            SizedBox(
                              width: width * 0.3,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: model.beforePriceController,
                                decoration: const InputDecoration(
                                    label: Text('割引前価格'),
                                    hintText: '割引前価格',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(width: width * 0.05),
                            const Text(
                              '→',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: width * 0.05),
                            const Icon(Icons.currency_yen),
                            SizedBox(
                              width: width * 0.3,
                              child: TextFormField(
                                controller: model.afterPriceController,
                                decoration: const InputDecoration(
                                    label: Text('割引後価格'),
                                    hintText: '割引後価格',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: height * 0.05,
                        ),
                        const Text('・メニュー詳細',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLines: 3,
                          maxLength: 150,
                          controller: model.menuIntroductionController,
                          decoration: const InputDecoration(
                              hintText:
                                  '（例）大人1人と小学生迄のお子さん1人のカットです。¥5500シャンプーブロー込み。',
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(height: height * 0.05),
                        const Text('・施術時間',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.watch_later_outlined),
                            SizedBox(
                              width: width * 0.5,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: model.treatmentTimeController,
                                decoration: const InputDecoration(
                                    label: Text('施術時間'),
                                    hintText: '〇〇分',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const Text(
                              '分',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        const Divider(),
                        SizedBox(height: height * 0.05),
                        const Text('ロングヘアーの別途料金の支払いが発生しますか？'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: model.isNeedExtraMoney,
                                onChanged: (bool? value) {
                                  setState(() {
                                    model.isNeedExtraMoney = value!;
                                  });
                                }),
                            const Text('発生する'),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          width: width * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black26,
                            ),
                            onPressed: () {
                              model.menuAddButton(context);
                            },
                            child: const Text('登録する'),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (model.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        );
      }),
    );
  }
}
