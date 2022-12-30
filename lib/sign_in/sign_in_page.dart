import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import '../common_widget/auth_form_field.dart';
import '../common_widget/vishu_app_bar.dart';
import '../sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: vishuAppBar(
        appBarTitle: 'salon Vishu',
      ),
      body: Consumer<SignInModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Column(
              children: [
                vishuImage(deviceHeight * 0.25, deviceWidth),
                const SizedBox(height: 30),
                AuthFormField(
                    isSuffixIcon: false,
                    isVisivilly: false,
                    isPicker: false,
                    width: deviceWidth,
                    signInModel: model,
                    textEditingController: model.emailController,
                    icon: Icons.email,
                    hintText: 'メールアドレス'),
                const SizedBox(height: 20),
                AuthFormField(
                    isSuffixIcon: true,
                    isVisivilly: false,
                    isPicker: false,
                    width: deviceWidth,
                    signInModel: model,
                    textEditingController: model.passController,
                    icon: Icons.password,
                    hintText: 'パスワード'),
                SizedBox(height: deviceHeight * 0.03),
                SizedBox(
                  width: deviceWidth * 0.7,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54),
                      onPressed: () {
                        model.signInTransition(context);
                      },
                      child: const Text('ログイン')),
                ),
                SizedBox(height: deviceHeight * 0.03),
                const Divider(),
                const Text(
                  '連携してログインされる方はこちら',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: deviceHeight * 0.03),
                SignInButton(Buttons.Apple, onPressed: () {}),
                SizedBox(height: deviceHeight * 0.02),
                SignInButton(Buttons.Google, onPressed: () {
                  model.signInWithGoogle(context);
                }),
                SizedBox(height: deviceHeight * 0.02),
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

Container vishuImage(double deviceHeight, double width) {
  return Container(
    height: deviceHeight,
    width: width,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('images/LILIA-BEAUTY.jpeg'))),
  );
}

///Ballet
///Dancing Script
