import 'package:flutter/material.dart';

typedef void StringCallback(String text);

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.onObscureTextTap,
    this.labelText = "Password",
  }) : super(key: key);

  final StringCallback onFieldSubmitted;
  final StringCallback validator;
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onObscureTextTap;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          fontFamily: "CircularStd-Book",
          fontSize: 16.0,
          color: Colors.black,
          decoration: TextDecoration.none),
      controller: controller,
      keyboardType: TextInputType.text,
      validator: (text) => text == null ? "Please provide a password" : null,
      autofocus: false,
      obscureText: obscureText,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        suffixIcon: onObscureTextTap == null
            ? null
            : InkWell(
                borderRadius: BorderRadius.circular(45),
                onTap: () {
                  onObscureTextTap();
                },
                child: ImageIcon(
                  obscureText
                      ? AssetImage("assets/icons/ic_eye_off.png")
                      : AssetImage("assets/icons/ic_eye_on.png"),
                  color: Colors.pink,
                ),
              ),
        prefixIcon: Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
            // padding: const EdgeInsetsDirectional.only(start: 10.0),
            child: Image.asset(
              "assets/icons/3.0x/ic_lock@3x.png",
              scale: 3.0,
            ),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
        // hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500]),
        // hintText: "Username",
        labelText: labelText,
      ),
    );
  }
}
