import 'package:flutter/material.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/auth_service.dart';

class PassResetPage extends StatefulWidget {
  const PassResetPage({Key? key}) : super(key: key);

  @override
  State<PassResetPage> createState() => _PassResetPageState();
}

class _PassResetPageState extends State<PassResetPage> {
  final resetMailController = TextEditingController();

  final auth = AuthPassReset();

  final focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    resetMailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: vishuAppBar(appBarTitle: 'password reset', isJapanese: false),
      body: SingleChildScrollView(
        child: Focus(
          focusNode: focusNode,
          child: GestureDetector(
            onTap: focusNode.requestFocus,
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.03),
                  const Icon(Icons.mail, size: 50),
                  SizedBox(height: height * 0.03),
                  const Text('パスワードを再設定',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.05),
                  const Text('メールアドレスを入力してください',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: resetMailController,
                      decoration:
                          const InputDecoration(hintText: 'xxxx@example.com'),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  SizedBox(
                      width: width * 0.7,
                      child: ElevatedButton(
                          onPressed: () async {
                            String result = await auth
                                .sendPassResetEmail(resetMailController.text);
                            if (result == 'success') {
                              Navigator.pop(context);
                            } else if (result == 'ERROR_INVALID_EMAIL') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('無効なメールアドレスです')));
                            } else if (result == 'ERROR_USER_NOT_FOUND') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('メールが登録されていません')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('メールの送信に失敗しました')));
                            }
                          },
                          child: const Text('メール送信'))),
                  SizedBox(height: height * 0.3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
