import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/domain/profile.dart';
import 'package:salon_vishu/edit/edit_model.dart';
import '../common_widget/vishu_app_bar.dart';

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
        appBar: vishuAppBar(appBarTitle: 'edit'),
        body: Consumer<EditModel>(
          builder: (context, model, child) {
            Profile profile = widget.profile;

            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    if (model.file != null)
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(model.file!),
                      ),
                    if (model.file == null)
                      CircleAvatar(
                          radius: 64,
                          backgroundImage: profile.imgUrl != ''
                              ? NetworkImage(profile.imgUrl)
                              : const NetworkImage(
                                  'https://jobneta.sasamedia.net/miyashikai/wp-content/uploads/2017/02/default-avatar.png')),
                    TextButton(
                        onPressed: () {
                          model.registerAccountPhoto(context);
                        },
                        child: const Text(
                          'プロフィール写真を変更',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 30),
                    guidListTile(
                        model: model,
                        width: 80,
                        controller: model.nameController,
                        hintText: '名前'),
                    guidListTile(
                        model: model,
                        width: 60,
                        controller: model.emailController,
                        hintText: 'メール'),
                    guidListTile(
                        model: model,
                        width: 40,
                        isNumberOnly: true,
                        controller: model.telephoneNumberController,
                        hintText: '電話番号'),
                    guidListTile(
                        model: model,
                        width: 60,
                        picker: () async {
                          model.dateOfBirthPicker(context);
                        },
                        controller: model.dateOfBirthController,
                        hintText: '誕生日'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          model.editProfileInformation(context);
                        },
                        child: const Text('登録する'))
                  ],
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
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
        tileColor: HexColor('#dfd9cd'),
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
