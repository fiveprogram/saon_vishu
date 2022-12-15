import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_vishu/menu/menu_model.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

import '../sign_in/sign_in_model.dart';

final signInControllerProvider = ChangeNotifierProvider((ref) => SignInModel());

final signUpControllerProvider = ChangeNotifierProvider((ref) => SignUpModel());

final menuPageProvider = ChangeNotifierProvider((ref) => MenuModel());
