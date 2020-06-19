import 'package:equatable/equatable.dart';
import 'package:lockie/models/code.dart';

abstract class CodesEvent extends Equatable {
  const CodesEvent();

  @override
  List<Object> get props => [];
}

class LoadCodes extends CodesEvent {}

class CodeAdded extends CodesEvent {
  final Code code;

  const CodeAdded(this.code);

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'CodeAdded { code: $code }';
}

class CodeUpdated extends CodesEvent {
  final Code oldCode;
  final Code newCode;

  const CodeUpdated(this.oldCode, this.newCode);

  @override
  List<Object> get props => [oldCode, newCode];

  @override
  String toString() => 'CodeUpdated { oldCode: $oldCode, newCode: $newCode }';
}

class CodeDeleted extends CodesEvent {
  final Code code;

  const CodeDeleted(this.code);

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'CodeDeleted { code: $code }';
}

class CodesUpdated extends CodesEvent{
  final List<Code> codes;

  const CodesUpdated(this.codes);

  @override
  List<Object> get props => [codes];

  @override
  String toString() => 'CodesDeleted { codes: $codes }';
}