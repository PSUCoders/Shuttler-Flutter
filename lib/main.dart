import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler_flutter/blocs/authentication/authentication.dart';
import 'package:shuttler_flutter/respositories/user_repository.dart';
import 'package:shuttler_flutter/screens/login_screen.dart';
import 'package:shuttler_flutter/screens/sign_up_screen.dart';

/// Monitor all Transitions
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition);
  }
}

void main() async {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(Shuttler(
      userRepository: UserRepository(
          sharedPreferences: await SharedPreferences.getInstance())));
}

// This widget is the root of your application.
class Shuttler extends StatefulWidget {
  const Shuttler({Key key, @required this.userRepository}) : super(key: key);

  @override
  _ShuttlerState createState() => _ShuttlerState();

  final UserRepository userRepository;
}

class _ShuttlerState extends State<Shuttler> {
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc =
        AuthenticationBloc(userRepository: widget.userRepository);
    authenticationBloc.dispatch(AppStarted());
  }

  @override
  void dispose() {
    super.dispose();
    authenticationBloc.dispose();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.pink,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16, color: Colors.pink),
        hintStyle: TextStyle(fontSize: 16, color: Colors.pink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shuttler',
        theme: _buildTheme(),
        home: BlocBuilder(
          bloc: authenticationBloc,
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is AuthenticationAuthenticated) {
              // return HomeScreen();
              return LoginScreen();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginScreen();
            }
            if (state is AuthenticationLoading) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
