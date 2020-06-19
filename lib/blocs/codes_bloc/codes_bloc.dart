import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:lockie/repositories/codes_repository.dart';
import 'package:meta/meta.dart';

import 'codes_event.dart';
import 'codes_state.dart';

class CodesBloc extends Bloc<CodesEvent, CodesState> {
  final CodesRepository codesRepository;
  StreamSubscription _codesSubscription;

  CodesBloc({@required this.codesRepository});

  @override
  CodesState get initialState => CodesLoadInProgress();

  @override
  Stream<CodesState> mapEventToState(CodesEvent event) async* {
    if (event is LoadCodes) {
      yield* _mapLoadCodesToState();
    } else if (event is CodeAdded) {
      yield* _mapCodeAddedToState(event);
    } else if (event is CodeUpdated) {
      yield* _mapCodeUpdatedToState(event);
    } else if (event is CodeDeleted) {
      yield* _mapCodeDeletedToState(event);
    } else if (event is CodesUpdated) {
      yield* _mapCodesUpdatedToState(event);
    }
  }

  Stream<CodesState> _mapLoadCodesToState() async* {
    _codesSubscription?.cancel();
    _codesSubscription = codesRepository.codes().listen(
          (codes) => add(CodesUpdated(codes))
    );
  }

  Stream<CodesState> _mapCodeAddedToState(CodeAdded event) async* {
    codesRepository.addNewCode(event.code);
  }

  Stream<CodesState> _mapCodeUpdatedToState(CodeUpdated event) async* {
    codesRepository.updateCode(event.oldCode, event.newCode);
  }

  Stream<CodesState> _mapCodeDeletedToState(CodeDeleted event) async* {
    codesRepository.removeCode(event.code);
  }

  Stream<CodesState> _mapCodesUpdatedToState(CodesUpdated event) async* {
    yield CodesLoadSuccess(event.codes);
  }

  @override
  Future<void> close() {
    _codesSubscription?.cancel();
    return super.close();
  }
}