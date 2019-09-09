import 'package:flutter/material.dart';
import 'package:shuttler_flutter/widgets/custom_flat_button.dart';
import 'package:shuttler_flutter/widgets/email_input.dart';
import 'package:shuttler_flutter/widgets/password_input.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key key,
    @required this.emailController,
    @required this.passwordController,
    @required this.obscurePassword,
    @required this.emailNode,
    @required this.passwordNode,
    this.onObscureTextTap,
    this.onSignInTapped,
    this.formKey,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final FocusNode emailNode;
  final FocusNode passwordNode;
  final VoidCallback onObscureTextTap;
  final VoidCallback onSignInTapped;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    if (width > 400) {
      width = 400;
    }

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            child: EmailInput(
              controller: emailController,
              focusNode: emailNode,
              onFieldSubmitted: (text) {
                emailNode.unfocus();
                FocusScope.of(context).requestFocus(passwordNode);
              },
            ),
          ),
          SizedBox(
            width: width,
            child: PasswordInput(
              controller: passwordController,
              focusNode: passwordNode,
              obscureText: obscurePassword,
              onObscureTextTap: onObscureTextTap,
            ),
          ),
          Container(
            margin: MediaQuery.of(context).orientation == Orientation.portrait
                ? EdgeInsets.symmetric(vertical: 40)
                : EdgeInsets.symmetric(vertical: 20),
            child: CustomFlatButton(
              onPressed: onSignInTapped,
              label: "Sign In",
            ),
          ),
        ],
      ),
    );
  }
}
