import 'package:meta/meta.dart';

abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;

  SignUpButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  String toString() =>
      'SignUpButtonPressed { email: $email, password: $password }';
}

class SignInButtonPressed extends SignUpEvent {
  @override
  String toString() => 'SignInButtonPressed';
}
