import 'package:flutter/material.dart';
import 'package:shuttler_flutter/widgets/custom_flat_button.dart';
import 'package:shuttler_flutter/widgets/email_input.dart';
import 'package:shuttler_flutter/widgets/password_input.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key key,
    @required this.emailController,
    @required this.passwordController,
    @required this.passwordConfirmController,
    @required this.emailNode,
    @required this.passwordNode,
    @required this.passwordConfirmNode,
    this.onSignUpTapped,
    this.formKey,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final FocusNode emailNode;
  final FocusNode passwordNode;
  final FocusNode passwordConfirmNode;
  final VoidCallback onSignUpTapped;
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
            ),
          ),
          SizedBox(
            width: width,
            child: PasswordInput(
              controller: passwordController,
              focusNode: passwordNode,
            ),
          ),
          SizedBox(
            width: width,
            child: PasswordInput(
              controller: passwordConfirmController,
              focusNode: passwordConfirmNode,
              labelText: "Confirm Password",
            ),
          ),
          Container(
            margin: MediaQuery.of(context).orientation == Orientation.portrait
                ? EdgeInsets.symmetric(vertical: 40)
                : EdgeInsets.symmetric(vertical: 20),
            child: CustomFlatButton(
              onPressed: onSignUpTapped,
              label: "Register",
            ),
          ),
        ],
      ),
    );
  }
}
