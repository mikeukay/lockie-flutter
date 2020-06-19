import 'package:equatable/equatable.dart';
import 'package:lockie/models/code.dart';


abstract class NewCodeState extends Equatable {
  final Code code;
  final bool isNameValid = false;
  final bool isSeedValid = false;

  const NewCodeState({this.code});

  @override
  List<Object> get props => [];
}

class NewCodeInitial extends NewCodeState {
  final Code code = Code(name: '', seed: '');
}

class NewCodeInfo extends NewCodeState {
  final Code code;
  final bool isNameValid;
  final bool isSeedValid;

  NewCodeInfo({this.code, this.isNameValid, this.isSeedValid});

  @override
  List<Object> get props => [code, isNameValid, isSeedValid];
}

class NewCodeLoading extends NewCodeState {
  final Code code;

  NewCodeLoading({this.code});

  @override
  List<Object> get props => [code];
}

class NewCodeCreated extends NewCodeState {}