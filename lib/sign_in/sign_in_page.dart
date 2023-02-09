import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/sign_in/pass_reset/pass_reset_page.dart';
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: vishuAppBar(
        appBarTitle: 'salon Vishu',
      ),
      body: Consumer<SignInModel>(builder: (context, model, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Focus(
                focusNode: model.focusNode,
                child: GestureDetector(
                  onTap: model.focusNode.requestFocus,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset('images/initial_screen.png'),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          height: height * 0.05,
                          child: AuthFormField(
                              isSuffixIcon: false,
                              isVisivilly: false,
                              isPicker: false,
                              width: width,
                              signInModel: model,
                              textEditingController: model.emailController,
                              icon: Icons.email,
                              hintText: 'メールアドレス'),
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          height: height * 0.05,
                          child: AuthFormField(
                              isSuffixIcon: true,
                              isVisivilly: true,
                              isPicker: false,
                              width: width,
                              signInModel: model,
                              textEditingController: model.passController,
                              icon: Icons.password,
                              hintText: 'パスワード'),
                        ),
                        SizedBox(
                            height: height * 0.04,
                            child: Row(
                              children: [
                                SizedBox(width: width * 0.37),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PassResetPage()));
                                  },
                                  child: const Text(
                                    'パスワードを忘れた方はこちら',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.7,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#fcf8f6'),
                                  foregroundColor: Colors.black54),
                              onPressed: () {
                                model.signInTransition(context);
                              },
                              child: Text(
                                'ログイン',
                                style: TextStyle(
                                    fontSize: height * 0.022,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        const Divider(),
                        const Text(
                          '連携してログインされる方はこちら',
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.6,
                          child: SignInButton(Buttons.Apple, onPressed: () {
                            model.signInWithApple();
                          }),
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.6,
                          child: SignInButton(Buttons.Google, onPressed: () {
                            model.signInWithGoogle(context);
                          }),
                        ),
                        SizedBox(height: height * 0.02),
                        TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()));
                          },
                          child: const Text(
                            'アカウントをお持ちでない方はこちら',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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

///Ballet
///Dancing Script
