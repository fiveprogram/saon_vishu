import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/appBar.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import '../river_pods/river_pod.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final controllerModel = ref.watch(signUpControllerProvider.notifier);

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'Welcome to "vishu"'),
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            vishuImage(width),
            const SizedBox(height: 20),
            authFormField(
                icon: Icons.email,
                hintText: 'メールアドレス',
                controller: controllerModel,
                width: width,
                textController: controllerModel.emailController),
            const SizedBox(height: 10),
            authFormField(
                icon: Icons.password,
                hintText: 'パスワード',
                controller: controllerModel,
                width: width,
                textController: controllerModel.passController),
            const SizedBox(height: 10),
            authFormField(
                icon: Icons.person,
                hintText: '名前',
                controller: controllerModel,
                width: width,
                textController: controllerModel.nameController),
            const SizedBox(height: 10),
            authFormField(
                icon: Icons.calendar_month,
                hintText: '生年月日',
                controller: controllerModel,
                width: width,
                textController: controllerModel.birthDayController),
            const SizedBox(height: 10),
            authFormField(
                icon: Icons.numbers,
                hintText: '電話番号',
                controller: controllerModel,
                width: width,
                textController: controllerModel.telephoneNumberController),
            const SizedBox(height: 30),
            SizedBox(
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#676767'),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {},
                    child: const Text('新規登録'))),
          ],
        ),
      ),
    );
  }

  SizedBox authFormField(
      {required double width,
      required SignUpModel controller,
      required TextEditingController textController,
      required IconData icon,
      required String hintText}) {
    return SizedBox(
      height: 40,
      width: width * 0.8,
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          filled: true,
          fillColor: HexColor('#676767'),
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 10.0, color: Colors.white),
          icon: Icon(
            icon,
            color: HexColor('#676767'),
          ),
        ),
      ),
    );
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
