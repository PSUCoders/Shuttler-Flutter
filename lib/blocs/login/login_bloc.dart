import 'dart:async';
import 'package:flutter/services.dart';

import 'package:shuttler_flutter/blocs/authentication/authentication.dart';
import 'package:shuttler_flutter/blocs/login/login_event.dart';
import 'package:shuttler_flutter/blocs/login/login_state.dart';
import 'package:shuttler_flutter/respositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        FirebaseAuth auth = FirebaseAuth.instance;

        FirebaseUser user = await auth.signInWithEmailAndPassword(
            email: event.username, password: event.password);

        String token = await user.getIdToken();

        // final token = await authenticationBloc.userRepository.authenticate(
        //   username: event.username,
        //   password: event.password,
        // );

        authenticationBloc.dispatch(Login(token: token));
      } on PlatformException catch (error) {
        print(error);
        yield LoginFailure(error: error.message);
      }
    }
  }
}
