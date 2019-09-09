import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttler_flutter/blocs/authentication/authentication.dart';
import 'package:shuttler_flutter/blocs/signup/signup.dart';

import 'package:shuttler_flutter/models/user.dart';
import 'package:shuttler_flutter/utilities/config.dart';
import 'package:shuttler_flutter/utilities/validator.dart';
import 'package:shuttler_flutter/widgets/sign_up_form.dart';

const Color primaryColor1 = Color(0xFFF2014B);

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController passwordConfirmController;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode passwordConfirmNode;
  SignUpBloc signUpBloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    passwordConfirmNode = FocusNode();
    AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    signUpBloc = SignUpBloc(authenticationBloc: authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    passwordConfirmNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }

  Future<void> saveUser(FirebaseUser firebaseUser) async {
    User user = User.fromFirebase(firebaseUser);
    DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child('Users');
    print(user);
    usersRef.set(user);
  }

  Future<User> getUser(String uid) async {
    DataSnapshot snapshot;
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    snapshot = (await database.reference().child('Users/$uid').once()).value;
    print(snapshot);

    if (snapshot == null) {
      return null;
    }

    return User.fromSnapshot(snapshot);
  }

  Future<DataSnapshot> getSnapshot(String child) async {
    DataSnapshot snapshot;
    final FirebaseDatabase database = FirebaseDatabase.instance;
    snapshot = await database.reference().child(child).once();

    return snapshot;
  }

  Widget buildLogo() {
    return SizedBox(
      child: Image.asset(
        "assets/icons/ic_logo.png",
      ),
    );
  }

  Widget buildBottomSheet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already registered? ",
          style: TextStyle(
            fontFamily: "CircularStd-Book",
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.all(0.0),
          pressedOpacity: 0.5,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Sign in",
            style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: primaryColor1,
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

  Widget buildSignUpScreen(BuildContext context) {
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
                child: SignUpForm(
                  formKey: formKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  passwordConfirmController: passwordConfirmController,
                  emailNode: emailNode,
                  passwordNode: passwordNode,
                  passwordConfirmNode: passwordConfirmNode,
                  onSignUpTapped: () {
                    print("sign up");
                    // bool noValidateError = formKey.currentState.validate();
                    // if (noValidateError) {
                    //   loginBloc.dispatch(LoginButtonPressed(
                    //     username: emailController.text,
                    //     password: passwordController.text,
                    //   ));
                    // }
                  },
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: buildBottomSheet(),
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
        bloc: signUpBloc,
        listener: (context, state) {
          if (state is SignUpFailure) {
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
          bloc: signUpBloc,
          builder: (context, state) {
            if (state is SignUpInitial) {
              return SafeArea(
                child: buildSignUpScreen(context),
              );
            }

            if (state is SignUpLoading) {
              return Stack(
                children: <Widget>[
                  Container(),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }

            if (state is SignUpFailure) {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
