import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';

import '../appBar.dart';
import '../river_pods/river_pod.dart';
import '../sign_up/sign_up_page.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final controllerModel = ref.watch(signInControllerProvider.notifier);

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'salon "vishu"'),
      body: Column(
        children: [
          vishuImage(width),
          const SizedBox(height: 10),
          authFormField(
              icon: Icons.email,
              hintText: 'メールアドレス',
              controller: controllerModel,
              width: width,
              textController: controllerModel.emailController),
          const SizedBox(height: 20),
          authFormField(
              icon: Icons.password,
              hintText: 'パスワード',
              controller: controllerModel,
              width: width,
              textController: controllerModel.passController),
          const SizedBox(height: 30),
          SizedBox(
              width: 300,
              child:
                  ElevatedButton(onPressed: () {}, child: const Text('ログイン'))),
          const SizedBox(height: 30),
          const Divider(),
          const Text(
            '連携してログインされる方はこちら',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          SignInButton(Buttons.Apple, onPressed: () {}),
          const SizedBox(height: 10),
          SignInButton(Buttons.Google, onPressed: () {}),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: 'アカウントをお持ちでない方はこちら',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox authFormField(
      {required double width,
      required SignInModel controller,
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
          fillColor: Colors.white54,
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 10.0, color: Colors.white54),
          icon: Icon(icon, color: Colors.white54),
        ),
      ),
    );
  }
}

Container vishuImage(double width) {
  return Container(
    height: 220,
    width: width,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('images/LILIA-BEAUTY.jpeg'))),
  );
}
