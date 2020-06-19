import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends Equatable {
  final String uid;
  final String email;

  User({this.uid, this.email});

  factory User.fromFirebaseUser(FirebaseUser user) {
    return User(uid: user.uid, email: user.email);
  }

  @override
  List<Object> get props => [uid, email];

  @override
  String toString() => 'User { uid: $uid, email: $email }';
}