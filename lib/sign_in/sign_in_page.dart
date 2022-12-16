import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/widget/appBar.dart';

import '../river_pods/river_pod.dart';
import '../sign_up/sign_up_page.dart';
import '../widget/auth_form_field.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(signInModelProvider.notifier);

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'salon "vishu"'),
      body: Column(
        children: [
          vishuImage(width),
          const SizedBox(height: 30),
          AuthFormField(
              isSuffixIcon: false,
              isVisivilly: false,
              isPicker: false,
              width: width,
              signInModel: model,
              textEditingController: model.emailController,
              icon: Icons.email,
              hintText: 'メールアドレス'),
          const SizedBox(height: 20),
          AuthFormField(
              isSuffixIcon: false,
              isVisivilly: false,
              isPicker: false,
              width: width,
              signInModel: model,
              textEditingController: model.emailController,
              icon: Icons.password,
              hintText: 'パスワード'),
          const SizedBox(height: 30),
          SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#f0fcf8'),
                    foregroundColor: Colors.black54),
                onPressed: () {},
                child: const Text('ログイン')),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const Text(
            '連携してログインされる方はこちら',
            style: TextStyle(color: Colors.black54),
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
}

Container vishuImage(double width) {
  return Container(
    height: 220,
    width: width,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('images/LILIA-BEAUTY.jpeg'))),
  );
}
