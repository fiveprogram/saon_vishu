import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import '../widget/appBar.dart';
import '../widget/auth_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<SignUpModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: 'Welcome to "vishu"'),
        body: Stack(
          children: [
            SizedBox(
              width: width,
              child: Column(
                children: [
                  vishuImage(width),
                  const SizedBox(height: 20),
                  AuthFormField(
                      isSuffixIcon: false,
                      isVisivilly: false,
                      isPicker: false,
                      width: width,
                      signUpModel: model,
                      textEditingController: model.emailController,
                      icon: Icons.email,
                      hintText: 'メールアドレス'),
                  const SizedBox(height: 10),
                  AuthFormField(
                      isSuffixIcon: true,
                      isVisivilly: false,
                      isPicker: false,
                      width: width,
                      signUpModel: model,
                      textEditingController: model.passController,
                      icon: Icons.password,
                      hintText: 'パスワード'),
                  const SizedBox(height: 10),
                  AuthFormField(
                      isSuffixIcon: false,
                      isVisivilly: false,
                      isPicker: false,
                      width: width,
                      signUpModel: model,
                      textEditingController: model.nameController,
                      icon: Icons.person,
                      hintText: '名前'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: width * 0.8,
                    child: TextFormField(
                      onTap: () {
                        model.birthDayPicker(context);
                      },
                      readOnly: true,
                      controller: model.birthDayController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        filled: true,
                        fillColor: HexColor('#f0fcf8'),
                        border: const OutlineInputBorder(),
                        hintText: '生年月日',
                        hintStyle: const TextStyle(
                            fontSize: 10.0, color: Colors.black54),
                        icon: Icon(
                          Icons.calendar_month,
                          color: HexColor('#f0fcf8'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: width * 0.8,
                    child: TextFormField(
                      controller: model.telephoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: HexColor('#f0fcf8'),
                        border: const OutlineInputBorder(),
                        hintText: '電話番号',
                        hintStyle: const TextStyle(
                            fontSize: 10.0, color: Colors.black54),
                        icon: Icon(
                          Icons.numbers,
                          color: HexColor('#f0fcf8'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor('#f0fcf8'),
                              foregroundColor: Colors.black54),
                          onPressed: () {
                            model.signUpTransition(context);
                          },
                          child: const Text('新規登録'))),
                ],
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
        ),
      );
    });
  }
}

Container vishuImage(double width) {
  return Container(
    height: 300,
    width: width,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('images/vishu_view.png'))),
  );
}
