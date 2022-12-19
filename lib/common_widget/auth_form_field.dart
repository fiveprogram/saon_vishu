import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon_vishu/sign_in/sign_in_model.dart';
import 'package:salon_vishu/sign_up/sign_up_model.dart';

// ignore: must_be_immutable
class AuthFormField extends StatefulWidget {
  double width;
  SignUpModel? signUpModel;
  SignInModel? signInModel;
  TextEditingController textEditingController;
  IconData icon;
  bool isSuffixIcon;
  bool isVisivilly = false;
  bool isPicker;
  String hintText;
  AuthFormField(
      {required this.width,
      this.signUpModel,
      this.signInModel,
      required this.textEditingController,
      required this.icon,
      required this.isSuffixIcon,
      required this.isVisivilly,
      required this.isPicker,
      required this.hintText,
      Key? key})
      : super(key: key);

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: widget.width * 0.8,
      child: TextFormField(
        style: const TextStyle(fontSize: 13),
        obscureText: widget.isVisivilly,
        controller: widget.textEditingController,
        onTap: widget.isPicker
            ? () {
                widget.signUpModel!.dateOfBirthPicker(context);
              }
            : null,
        decoration: InputDecoration(
          suffixIcon: widget.isSuffixIcon
              ? IconButton(
                  icon: widget.isVisivilly
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      widget.isVisivilly = !widget.isVisivilly;
                    });
                  })
              : null,
          filled: true,
          fillColor: HexColor('#dfd9cd'),
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 10.0, color: Colors.black54),
          icon: Icon(
            widget.icon,
            color: HexColor('#dfd9cd'),
          ),
        ),
      ),
    );
  }
}
