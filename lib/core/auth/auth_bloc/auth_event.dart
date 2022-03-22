part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Logout extends AuthEvent {}

class GoogleSignIn extends AuthEvent {}

class AppUserChanged extends AuthEvent {
  @override
  List<Object> get props => [];
}
