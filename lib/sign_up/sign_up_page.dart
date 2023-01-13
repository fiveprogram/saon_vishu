import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import '../common_widget/auth_form_field.dart';
import '../common_widget/vishu_app_bar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<SignUpModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(
          appBarTitle: 'salon Vishu',
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: deviceWidth,
                child: Column(
                  children: [
                    vishuImage(deviceHeight * 0.3, deviceWidth),
                    SizedBox(height: deviceHeight * 0.025),
                    AuthFormField(
                        isSuffixIcon: false,
                        isVisivilly: false,
                        isPicker: false,
                        width: deviceWidth,
                        signUpModel: model,
                        textEditingController: model.emailController,
                        icon: Icons.email,
                        hintText: 'メールアドレス'),
                    SizedBox(height: deviceHeight * 0.015),
                    AuthFormField(
                        isSuffixIcon: true,
                        isVisivilly: false,
                        isPicker: false,
                        width: deviceWidth,
                        signUpModel: model,
                        textEditingController: model.passController,
                        icon: Icons.password,
                        hintText: 'パスワード'),
                    SizedBox(height: deviceHeight * 0.015),
                    AuthFormField(
                        isSuffixIcon: false,
                        isVisivilly: false,
                        isPicker: false,
                        width: deviceWidth,
                        signUpModel: model,
                        textEditingController: model.nameController,
                        icon: Icons.person,
                        hintText: '名前'),
                    SizedBox(height: deviceHeight * 0.015),
                    SizedBox(
                      height: 40,
                      width: deviceWidth * 0.8,
                      child: TextFormField(
                        onTap: () {
                          model.dateOfBirthPicker(context);
                        },
                        readOnly: true,
                        controller: model.dateOfBirthController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          filled: true,
                          fillColor: HexColor('#fcf8f6'),
                          border: const OutlineInputBorder(),
                          hintText: '生年月日',
                          hintStyle: const TextStyle(
                              fontSize: 10.0, color: Colors.black54),
                          icon: Icon(
                            Icons.calendar_month,
                            color: HexColor('#fcf8f6'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.015),
                    SizedBox(
                      height: deviceHeight * 0.05,
                      width: deviceWidth * 0.8,
                      child: TextFormField(
                        controller: model.telephoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#fcf8f6'),
                          border: const OutlineInputBorder(),
                          hintText: '電話番号',
                          hintStyle: const TextStyle(
                              fontSize: 10.0, color: Colors.black54),
                          icon: Icon(
                            Icons.numbers,
                            color: HexColor('#fcf8f6'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: deviceWidth * 0.1),
                        Icon(
                          Icons.device_hub,
                          color: HexColor('#fcf8f6'),
                        ),
                        SizedBox(width: deviceWidth * 0.03),
                        Container(
                          height: 40,
                          width: deviceWidth * 0.7,
                          decoration: BoxDecoration(
                              color: HexColor('#fcf8f6'),
                              border: Border.all(color: Colors.black54)),
                          child: Row(
                            children: [
                              Radio(
                                  value: '男性',
                                  groupValue: model.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      model.gender = value;
                                    });
                                  }),
                              const Text(
                                '男性',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              SizedBox(width: deviceWidth * 0.1),
                              Radio(
                                  value: '女性',
                                  groupValue: model.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      model.gender = value;
                                    });
                                  }),
                              const Text(
                                '女性',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black54),
                            onPressed: () {
                              model.signUpTransition(context);
                            },
                            child: const Text(
                              '新規登録',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ),
              if (model.isLoading)
                Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}

Container vishuImage(double deviceHeight, double width) {
  return Container(
    height: deviceHeight,
    width: width,
    decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('images/vishu_view.png'))),
  );
}
