import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common_widget/vishu_app_bar.dart';
import '../../domain/profile.dart';

import 'edit_model.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  Profile profile;
  EditPage({required this.profile, Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditModel>(
      create: (_) => EditModel(profile: widget.profile),
      child: Scaffold(
        appBar: vishuAppBar(appBarTitle: 'my page'),
        body: Consumer<EditModel>(
          builder: (context, model, child) {
            Profile profile = widget.profile;

            final height = MediaQuery.of(context).size.height;
            final double width = MediaQuery.of(context).size.width;

            return WillPopScope(
              onWillPop: () async {
                return model.willPopCallback(context);
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Focus(
                      focusNode: model.focusNode,
                      child: GestureDetector(
                        onTap: model.focusNode.requestFocus,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            if (model.file != null)
                              GestureDetector(
                                onTap: () {
                                  model.registerAccountPhoto(context);
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 64,
                                      backgroundImage: FileImage(model.file!),
                                    ),
                                    const Positioned(
                                      top: 97,
                                      right: 12,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          radius: 16,
                                          child: Icon(Icons.add,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.file == null)
                              GestureDetector(
                                onTap: () {
                                  model.registerAccountPhoto(context);
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                        radius: 64,
                                        backgroundImage: profile.imgUrl != ''
                                            ? NetworkImage(profile.imgUrl)
                                            : const NetworkImage(
                                                'https://jobneta.sasamedia.net/miyashikai/wp-content/uploads/2017/02/default-avatar.png')),
                                    const Positioned(
                                      top: 97,
                                      right: 12,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          radius: 16,
                                          child: Icon(Icons.add,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: height * 0.05),
                            guidListTile(
                                model: model,
                                width: 80,
                                controller: model.nameController,
                                hintText: '名前'),
                            guidListTile(
                                model: model,
                                width: 40,
                                isNumberOnly: true,
                                controller: model.telephoneNumberController,
                                hintText: '電話番号'),
                            guidListTile(
                                model: model,
                                width: 40,
                                picker: () async {
                                  model.dateOfBirthPicker(context);
                                },
                                controller: model.dateOfBirthController,
                                hintText: '生年月日'),
                            Container(
                              height: 60,
                              width: width,
                              decoration: BoxDecoration(
                                  color: HexColor('#fcf8f6'),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: HexColor('#7e796e')))),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.33,
                                      child: RadioListTile(
                                        title: const Text("男性"),
                                        value: "男性",
                                        groupValue: model.gender,
                                        onChanged: (value) {
                                          setState(() {
                                            model.gender = value.toString();
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.33,
                                      child: RadioListTile(
                                        title: const Text("女性"),
                                        value: "女性",
                                        groupValue: model.gender,
                                        onChanged: (value) {
                                          setState(() {
                                            model.gender = value.toString();
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.35,
                                      child: RadioListTile(
                                        title: const Text("その他"),
                                        value: "その他",
                                        groupValue: model.gender,
                                        onChanged: (value) {
                                          setState(() {
                                            model.gender = value.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.1),
                            SizedBox(
                              height: height * 0.06,
                              width: width * 0.5,
                              child: ElevatedButton(
                                  onPressed: () {
                                    model.editProfileInformation(context);
                                  },
                                  child: const Text(
                                    '保存する',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ),
                            SizedBox(height: height * 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container guidListTile({
    required EditModel model,
    required double width,
    required TextEditingController controller,
    required String hintText,
    Future<void> Function()? picker,
    bool? isNumberOnly,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: HexColor('#7e796e')))),
      child: ListTile(
        tileColor: HexColor('#fcf8f6'),
        leading: Text(hintText,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
            )),
        title: SizedBox(
          width: 200,
          child: Row(
            children: [
              SizedBox(width: width),
              Expanded(
                child: TextFormField(
                  onTap: picker,
                  readOnly: picker != null ? true : false,
                  keyboardType:
                      isNumberOnly != null ? TextInputType.number : null,
                  inputFormatters: isNumberOnly != null
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
