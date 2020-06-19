import 'package:equatable/equatable.dart';
import 'package:lockie/models/code.dart';

abstract class CodesState extends Equatable {
  const CodesState();

  @override
  List<Object> get props => [];
}

class CodesLoadInProgress extends CodesState {}

class CodesLoadSuccess extends CodesState {
  final List<Code> codes;

  const CodesLoadSuccess([this.codes = const []]);

  @override
  List<Object> get props => [codes];

  @override
  String toString() => 'CodesLoadSuccess { codes: $codes }';
}

class CodesLoadFailure extends CodesState {}