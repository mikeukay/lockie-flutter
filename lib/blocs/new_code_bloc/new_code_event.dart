import 'package:equatable/equatable.dart';
import 'package:lockie/models/code.dart';

abstract class NewCodeEvent extends Equatable {
  const NewCodeEvent();

  @override
  List<Object> get props => [];
}

class NewCodeModified extends NewCodeEvent {
  final Code code;

  NewCodeModified({this.code});

  @override
  List<Object> get props => [code];
}

class NewCodeNameModified extends NewCodeEvent {
  final Code code;
  final String name;

  NewCodeNameModified({this.name, this.code});

  @override
  List<Object> get props => [name, code];
}

class NewCodeSeedModified extends NewCodeEvent {
  final Code code;
  final String seed;

  NewCodeSeedModified({this.seed, this.code});

  @override
  List<Object> get props => [seed, code];
}

class NewCodeLocalImagePathModified extends NewCodeEvent {
  final Code code;
  final String localImagePath;

  NewCodeLocalImagePathModified({this.localImagePath, this.code});

  @override
  List<Object> get props => [localImagePath, code];
}

class NewCodeSubmit extends NewCodeEvent {
  final Code code;

  NewCodeSubmit({this.code});

  @override
  List<Object> get props => [code];
}