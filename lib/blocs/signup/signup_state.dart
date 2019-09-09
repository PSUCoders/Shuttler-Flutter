import 'package:meta/meta.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {
  @override
  String toString() => 'SignUpInitial';
}

class SignUpLoading extends SignUpState {
  @override
  String toString() => 'SignUpLoading';
}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({@required this.error});

  @override
  String toString() => 'SignUpFailure { error: $error }';
}
