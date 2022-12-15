import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import '../river_pods/river_pod.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final controllerModel = ref.watch(signUpControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to "Vishu"',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
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
            const SizedBox(height: 40),
            SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('新規登録'))),
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
      width: width * 0.9,
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon),
        ),
      ),
    );
  }

  Container vishuImage(double width) {
    return Container(
      height: 300,
      width: width,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/vishu_view.png'))),
    );
  }
}
