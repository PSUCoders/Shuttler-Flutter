import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shuttler_flutter/blocs/authentication/authentication.dart';
import 'package:shuttler_flutter/respositories/user_repository.dart';
import "package:shuttler_flutter/utilities/validator.dart";
import "./signup_event.dart";
import "./signup_state.dart";
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationBloc authenticationBloc;

  SignUpBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  SignUpState get initialState => SignUpInitial();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();

      try {
        if (!isPlattsburgh(event.email)) {
          yield SignUpFailure(error: "Not Plattsburgh email");
          return;
        }

        FirebaseAuth auth = FirebaseAuth.instance;
        FirebaseUser user = await auth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);

        print(user.displayName);
        print(user.email);

        // if successful sign up, persist token

        yield SignUpInitial();
      } catch (error) {
        yield SignUpFailure(error: error.toString());
      }
    }
  }
}
