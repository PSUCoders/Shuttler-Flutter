import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shuttler_flutter/models/user.dart';
import 'package:shuttler_flutter/utilities/config.dart';
import 'package:shuttler_flutter/screens/home/home.dart';
import 'package:shuttler_flutter/screens/login/verify.dart';
import 'package:shuttler_flutter/utilities/validator.dart';

const Color primaryColor1 = Color(0xFFF2014B);

const String ERROR_CODE_00 = "User is not registered";
const String ERROR_CODE_01 =
    "The password is invalid or the user does not have a password";
const String ERROR_CODE_02 = "The email address is badly formatted";
const String ERROR_CODE_03 =
    "There is no user record corresponding to this identifier. The user may have been deleted";
const String ERROR_CODE_04 = "Given String is empty or null";
const String ERROR_CODE_05 = "Password should be at least 6 characters";
const String ERROR_CODE_06 =
    "The email address is already in use by another account";

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TODO detect Enter key to go to next form field
  GlobalKey<ScaffoldState> _scaffoldKey;
  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> _emailKey;
  GlobalKey<FormState> _passwordKey;
  GlobalKey<FormState> _password2Key;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController password2Controller;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode password2Node;
  String emailErrorMessage;
  String passwordErrorMessage;
  String password2ErrorMessage;

  bool _isPasswordValid;
  bool _isEmailUsed;

  @override
  initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _formKey = GlobalKey<FormState>();
    _emailKey = GlobalKey<FormState>();
    _passwordKey = GlobalKey<FormState>();
    _password2Key = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    password2Controller = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    password2Node = FocusNode();
    _isEmailUsed = false;
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    password2Node.dispose();
    emailController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
  }

  String validateEmail(String input) {
    if (_isEmailUsed) {
      return emailErrorMessage;
    }
    if (isPlattsburgh(input)) {
      return null;
    }
    return emailErrorMessage;
  }

  String validatePassword(String input) {
    if (isPassword(input)) {
      _isPasswordValid = true;
      return null;
    }
    _isPasswordValid = false;
    return passwordErrorMessage;
  }

  String validatePassword2(String input) {
    if (!_isPasswordValid) {
      return null;
    }
    if (password2Controller.text != passwordController.text) {
      return "Password didn't match. Please try again";
    }
    if (isPassword(input)) {
      return null;
    }
    return password2ErrorMessage;
  }

  Future<void> saveUser(FirebaseUser firebaseUser) async {
    User user = User.fromFirebase(firebaseUser);
    DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child('Users');
    print(user);
    usersRef.set(user);
  }

  void submitForm() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String signUpEmail = (isStudentID(emailController.text)
          ? emailController.text + "@plattsburgh.edu"
          : emailController.text);

      bool validationResult = this._formKey.currentState.validate();
      if (validationResult) {
        this._formKey.currentState.save();

        FirebaseUser user = await auth.createUserWithEmailAndPassword(
            email: signUpEmail, password: passwordController.text);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => VerifyAccountScreen(user)));
      }
    } catch (e) {
      print("An error occurs");
      print(e);

      if (e.toString().contains(ERROR_CODE_05)) {
        passwordErrorMessage = "Password should be at least 6 characters";
        password2ErrorMessage = null;
        password2Controller.clear();
        // FocusScope.of(context).requestFocus(passwordNode);
      } else if (e.toString().contains(ERROR_CODE_06)) {
        passwordController.clear();
        password2Controller.clear();
        emailErrorMessage =
            "The email address is already in use by another account";
        _isEmailUsed = true;
        // showSnackbar("The email address is already in use by another account");
        return;
      }

      this._formKey.currentState.validate();

      // print("this was ran");
    }
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

  void showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(text),
    ));
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xFFF2014B),
          onPressed: submitForm,
          child: Text("Register")),
    );
  }

  Widget emailInput() {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.only(top: 50.0),
        margin: const EdgeInsets.all(10.0),
        width: screenSize.width * 4 / 5,
        child: TextFormField(
          style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontSize: 16.0,
              color: Colors.black,
              decoration: TextDecoration.none),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          // autovalidate: true,
          autofocus: false,
          focusNode: emailNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            emailNode.unfocus();
            FocusScope.of(context).requestFocus(passwordNode);
          },
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
                // padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Image.asset(
                  "assets/icons/3.0x/ic_user@3x.png",
                  scale: 3.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
            // hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500]),
            // hintText: "Username",
            labelText: "Username or email",
          ),
        ));
  }

  Widget passwordInput() {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(10.0),
      width: screenSize.width * 4 / 5,
      child: TextFormField(
        // key: _passwordKey,
        style: TextStyle(
            fontFamily: "CircularStd-Book",
            fontSize: 16.0,
            color: Colors.black),
        controller: passwordController,
        keyboardType: TextInputType.text,
        validator: validatePassword,
        focusNode: passwordNode,
        obscureText: true,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (term) {
          passwordNode.unfocus();
          FocusScope.of(context).requestFocus(password2Node);
        },
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              child: Image.asset(
                "assets/icons/3.0x/ic_lock@3x.png",
                scale: 3.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          labelText: "Password",
        ),
      ),
    );
  }

  Widget password2Input() {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(10.0),
      width: screenSize.width * 4 / 5,
      child: TextFormField(
        // key: _password2Key,
        style: TextStyle(
            fontFamily: "CircularStd-Book",
            fontSize: 16.0,
            color: Colors.black),
        controller: password2Controller,
        keyboardType: TextInputType.text,
        validator: validatePassword2,
        obscureText: true,
        focusNode: password2Node,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              child: Image.asset(
                "assets/icons/3.0x/ic_lock@3x.png",
                scale: 3.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          labelText: "Confirm password",
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Already registered? ",
              style: TextStyle(
                  fontFamily: "CircularStd-Book",
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black)),
          CupertinoButton(
            padding: EdgeInsets.all(0.0),
            pressedOpacity: 0.5,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Sign in",
                style: TextStyle(
                    fontFamily: "CircularStd-Book",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor1)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: new Material(
          child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: screenSize.width * 4 / 5,
                  child: ListView(children: <Widget>[
                    SizedBox(
                      height: screenSize.height / 10,
                    ),
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "assets/icons/3.0x/ic_logo@3x.png",
                        scale: 3.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height / 10,
                    ),
                    Text(
                      "Don't Miss The Shuttle Any More!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "CircularStd-Book",
                          fontSize: 18.0,
                          color: Colors.black54),
                    ),
                    emailInput(),
                    passwordInput(),
                    password2Input(),
                    SizedBox(
                      height: screenSize.height / 20,
                    ),
                    signUpButton(),
                  ]),
                ),
              ),
            ),
            _buildBottomSheet(),
          ],
        ),
      )),
    );
  }
}
