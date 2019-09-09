import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttler_flutter/blocs/authentication/authentication.dart';
import 'package:shuttler_flutter/blocs/login/login.dart';
import 'package:shuttler_flutter/screens/sign_up_screen.dart';
import 'package:shuttler_flutter/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  bool obscurePassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    loginBloc = LoginBloc(authenticationBloc: authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget buildSignInNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "First time using Shuttler? ",
          style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
        CupertinoButton(
          padding: EdgeInsets.all(0.0),
          pressedOpacity: 0.5,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Text(
            "Register",
            style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "CircularStd-Book",
          fontSize: 18.0,
          color: Colors.black54),
    );
  }

  Widget buildLogo() {
    return SizedBox(
      child: Image.asset(
        "assets/icons/ic_logo.png",
      ),
    );
  }

  Widget buildLoginScreen(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: height * 0.3,
                  child: buildLogo(),
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: buildSubtitle("Don't Miss The Shuttle Anymore!"),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? height * 0.5
                        : null,
                child: LoginForm(
                  formKey: formKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  obscurePassword: obscurePassword,
                  emailNode: emailNode,
                  passwordNode: passwordNode,
                  onObscureTextTap: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  onSignInTapped: () {
                    print("sign in");
                    bool noValidateError = formKey.currentState.validate();
                    if (noValidateError) {
                      loginBloc.dispatch(LoginButtonPressed(
                        username: emailController.text,
                        password: passwordController.text,
                      ));
                    }
                  },
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: buildSignInNavigation(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder(
        bloc: loginBloc,
        builder: (context, state) {
          if (state is LoginInitial) {
            return buildLoginScreen(context);
          }

          if (state is LoginLoading) {
            return Stack(
              children: <Widget>[
                buildLoginScreen(context),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          }

          if (state is LoginFailure) {
            return buildLoginScreen(context);
          }
        },
      ),
    ));
  }
}
