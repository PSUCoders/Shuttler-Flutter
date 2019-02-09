import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shuttler_ios/screens/home/driver_home.dart';

import 'package:shuttler_ios/utilities/dataset.dart';
import 'package:shuttler_ios/models/user.dart';
import 'package:shuttler_ios/screens/home/home.dart';
import 'package:shuttler_ios/screens/login/signup.dart';
import 'package:shuttler_ios/screens/login/verify.dart';
import 'package:shuttler_ios/utilities/validator.dart';

const Color primaryColor1 = Color(0xFFF2014B);

const String ERROR_CODE_00 = "User is not registered";
const String ERROR_CODE_01 =
    "The password is invalid or the user does not have a password";
const String ERROR_CODE_02 = "The email address is badly formatted";
const String ERROR_CODE_03 =
    "There is no user record corresponding to this identifier. The user may have been deleted";
const String ERROR_CODE_04 = "Given String is empty or null";

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO detect Enter key to go to next form field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController;
  TextEditingController passwordController;
  FocusNode emailNode;
  FocusNode passwordNode;
  String emailErrorMessage;
  String passwordErrorMessage;
  bool showPassword;
  String showPasswordURL;
  FirebaseUser user;
  FirebaseMessaging _firebaseMessaging;

  @override
  initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    emailErrorMessage = "Invalid email or username";
    passwordErrorMessage = "Invalid password";
    showPassword = false;
    showPasswordURL = "assets/icons/3.0x/ic_eye_off@3x.png";
    _firebaseMessaging = FirebaseMessaging();
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void submitForm() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Convert to email when user type username instead of email
      String signInEmail = (isStudentID(emailController.text)
          ? emailController.text + "@plattsburgh.edu"
          : emailController.text);
      var userFirebase = await _auth.signInWithEmailAndPassword(
          email: signInEmail, password: passwordController.text);

      final bool isDriver = await isDriverAccount();
      if (isDriver) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => DriverHomeScreen()),
        );
      } else {
        if (userFirebase.isEmailVerified) {

          var token = await _firebaseMessaging.getToken();
          DataSnapshot snapshot = await FirebaseDatabase.instance
              .reference()
              .child('Users/${userFirebase.uid}')
              .once();

          /// Check whether the token of the current device is saved on database or not
          /// If not, save it.
          Map notiTokens = snapshot.value;

          if (!notiTokens.containsKey(token)) {
            DatabaseReference tokenRef = FirebaseDatabase.instance
                .reference()
                .child('Users/${userFirebase.uid}/notifications/tokens/$token');
            tokenRef.set(true);
            snapshot = await FirebaseDatabase.instance
                .reference()
                .child('Users/${userFirebase.uid}')
                .once();
          }

          User u = User.fromSnapshot(snapshot);
          Dataset.currentUser.value = u;
          Dataset.token.value = token;
          print("token is " + Dataset.token.value);
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => VerifyAccountScreen(userFirebase)),
          );
        }
      }
    } catch (e) {
      print(e);
      if (e.toString().contains(ERROR_CODE_01)) {
        passwordErrorMessage = "Incorrect password";
      } else if (e.toString().contains(ERROR_CODE_02)) {
        // TODO handle username case and email case separately
        emailErrorMessage = "Incorrect format username or email";
      } else if (e.toString().contains(ERROR_CODE_03)) {
        showSnackbar("The user has not registered!");
      } else if (e.toString().contains(ERROR_CODE_04)) {
        emailErrorMessage = "Email or username cannot be blank";
        passwordErrorMessage = "Password cannot be blank";
      } else {
        print("Unhandled Error!");
        passwordErrorMessage = "Invalid password";
        emailErrorMessage = "Invalid email";
        showSnackbar("Unhandled Error!");
      }

      if (this._formKey.currentState.validate()) {
        this._formKey.currentState.save();
      }
    }
  }

  String validateEmail(String input) {
    if (isPlattsburgh(input)) {
      print("DEBUG: isPlattsburgh true");
      return null;
    }
    return emailErrorMessage;
  }

  String validatePassword(String input) {
    if (passwordErrorMessage != "Invalid password") {
      return passwordErrorMessage;
    }
    if (isPassword(input)) {
      return null;
    }
    return passwordErrorMessage;
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

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xFFF2014B),
          onPressed: submitForm,
          child: Text("Sign In")),
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
        style: TextStyle(
            fontFamily: "CircularStd-Book",
            fontSize: 16.0,
            color: Colors.black),
        controller: passwordController,
        keyboardType: TextInputType.text,
        obscureText: !showPassword,
        validator: validatePassword,
        focusNode: passwordNode,
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
          labelText: "Password",
          suffixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: CupertinoButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                  if (!showPassword) {
                    showPasswordURL = "assets/icons/3.0x/ic_eye_off@3x.png";
                  } else {
                    showPasswordURL = "assets/icons/3.0x/ic_eye_on@3x.png";
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                // padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Image.asset(
                  showPasswordURL,
                  scale: 3.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
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
                    SizedBox(
                      height: screenSize.height / 20,
                    ),
                    signInButton(),
                    SizedBox(
                      height: 100.0,
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("First time using Shuttler? ",
                    style: TextStyle(
                        fontFamily: "CircularStd-Book",
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                CupertinoButton(
                  padding: EdgeInsets.all(0.0),
                  pressedOpacity: 0.5,
                  onPressed: () {
                    this._formKey.currentState.reset();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text("Register",
                      style: TextStyle(
                          fontFamily: "CircularStd-Book",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor1)),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
