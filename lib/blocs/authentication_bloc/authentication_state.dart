import 'package:equatable/equatable.dart';
import 'package:lockie/models/user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  const AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AuthenticationSuccess { user: $user }';
}

class AuthenticationFailure extends AuthenticationState {}