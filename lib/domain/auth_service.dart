import 'package:firebase_auth/firebase_auth.dart';

class AuthPassReset {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> sendPassResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
