import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shuttler_ios/models/user.dart';
import 'package:shuttler_ios/utilities/config.dart';
import 'package:shuttler_ios/screens/home/home.dart';
import 'package:shuttler_ios/screens/login/verify.dart';
import 'package:shuttler_ios/utilities/validator.dart';

bool _isLogging = false;

const String ERROR_CODE_00 = "User is not registered";
const String ERROR_CODE_01 = "The password is invalid or the user does not have a password";
const String ERROR_CODE_02 = "The email address is badly formatted";
const String ERROR_CODE_03 = "There is no user record corresponding to this identifier. The user may have been deleted";
const String ERROR_CODE_04 = "Given String is empty or null";

class LoginWithEmailScreen extends StatefulWidget {
  @override
  _LoginWithEmailScreenState createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  // TODO detect Enter key to go to next form field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final passwordController = new TextEditingController();
  static final emailController = new TextEditingController();
  FocusNode emailNode;
  FocusNode passwordNode;
  String emailErrorMessage;
  String passwordErrorMessage;
  bool showPassword;
  String showPasswordURL = "assets/icons/2.0x/ic_eye_off@2x.png";
  FirebaseUser user;


  @override
  initState() {
    super.initState();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    emailErrorMessage = "Invalid email or username";
    passwordErrorMessage = "Invalid password";
    showPassword = false;
    // test();
  }
  
  @override
  void dispose(){
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
      String signInEmail = (isStudentID(emailController.text) ? emailController.text + "@plattsburgh.edu" : emailController.text);
      print("DEBUG signin email : " + signInEmail);
      var userFirebase = await _auth.signInWithEmailAndPassword(email: signInEmail, password: passwordController.text);
      print(userFirebase);

      if(userFirebase.isEmailVerified) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()),);
      }
      else {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => VerifyAccountScreen(userFirebase)),);
      }

    }
    catch (e) {
      print(e);
      if(e.toString().contains(ERROR_CODE_01)) {
        passwordErrorMessage = "Incorrect password";
      }
      else if(e.toString().contains(ERROR_CODE_02)) {
        // TODO handle username case and email case separately
        emailErrorMessage = "Incorrect format username or email";
      }
      else if (e.toString().contains(ERROR_CODE_03)) {
        showSnackbar("The user has not registered!");
      }
      else if (e.toString().contains(ERROR_CODE_04)) {
        emailErrorMessage = "Email or username cannot be blank";
        passwordErrorMessage = "Password cannot be blank";
      }
      else {
        print("Unhandled Error!");
        passwordErrorMessage = "Invalid password";
        emailErrorMessage = "Invalid email";
      }

      if(this._formKey.currentState.validate()) {
        this._formKey.currentState.save();
      }
      
    }
  }

  String validateEmail(String input) {
    if(isPlattsburgh(input)) {
      return null;
    }
    return emailErrorMessage;
  }

  String validatePassword(String input) {
    if(isPassword(input)) {
      return null;
    }
    return passwordErrorMessage;
  }

  Future<User> getUser(String uid) async {
    DataSnapshot snapshot;
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.
    snapshot = (await database.reference().child('Users/$uid').once()).value;
    print(snapshot);

    if(snapshot == null) {
      return null;
    }
    
    return User.fromSnapshot(snapshot);
  }

  void signIn() async {
    print("DEBUG signIn pressed");
    // user = await getUser(emailController.text);
    

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
    return Container(
      child: CupertinoButton(
        pressedOpacity: 0.5,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFFF2014B),
        onPressed: submitForm,
        child: Text("Sign In")
      ),
    );
  }

  Widget emailInput() {
    return Container(
      padding: const EdgeInsets.only(top: 50.0),
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
        style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, color: Colors.black, decoration: TextDecoration.none),
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
              child: Image.asset("assets/icons/2.0x/ic_user@2x.png", scale: 1.5,),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500]),
          // hintText: "Username",
          labelText: "Username",
        ),
      ));
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
        style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, color: Colors.black),
        controller: passwordController,
        keyboardType: TextInputType.text,
        obscureText: showPassword,
        validator: validatePassword,
        focusNode: passwordNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              child: Image.asset("assets/icons/2.0x/ic_lock@2x.png", scale: 1.5,),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500] ),
          hintText: 'Password',
          suffixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: CupertinoButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                  if(showPassword) { showPasswordURL = "assets/icons/2.0x/ic_eye_off@2x.png"; }  
                  else { showPasswordURL = "assets/icons/2.0x/ic_eye_on@2x.png"; }
                });
              },
               child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                // padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Image.asset(showPasswordURL, scale: 1.5,),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFFF2014B),textSelectionHandleColor:  Color(0xFFF2014B)),
      home: Scaffold(
        key: _scaffoldKey,
        body: new Material(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 1.0,
                    child: Image.asset(
                      "assets/icons/2.0x/ic_logo@2x.png", scale: 2.0,
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Text("Don't Miss The Shuttle Any More!", style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black38),),
                  emailInput(),
                  passwordInput(),
                  SizedBox(
                    height: 50.0,
                  ),
                  signInButton(),
                  SizedBox(
                    // height: 20.0,
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: submitForm,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    // height: 20.0,
                    child: IconButton(
                      icon: Icon(Icons.pause_circle_outline),
                      onPressed: () {
                        print("DEBUG user: $user");
                        submitForm();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    // height: 20.0,
                    child: IconButton(
                      icon: Icon(Icons.navigate_next),
                      onPressed: () {
                        if (user == null) return;
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => VerifyAccountScreen(user)),);
                      },
                    ),
                  ),
                  SizedBox(
                    // height: 20.0,
                    child: FlatButton(
                      onPressed: () { showSnackbar("DSD"); },
                      child: Text("Show Snackbar"),
                    )
                  )
                ]
              ),
            ),
          )
        ),
      ),
    );
  }
}
