import 'dart:io' as Io;
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as Img;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/codes_bloc/bloc.dart';
import 'package:lockie/models/code.dart';
import 'package:lockie/repositories/storage_repository.dart';
import 'package:blurhash/blurhash.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'new_code_event.dart';
import 'new_code_state.dart';

class NewCodeBloc extends Bloc<NewCodeEvent, NewCodeState> {

  CodesBloc codesBloc;
  StorageRepository storageRepository;

  NewCodeBloc({@required this.codesBloc, @required this.storageRepository});

  @override
  NewCodeState get initialState => NewCodeInitial();

  @override
  Stream<Transition<NewCodeEvent, NewCodeState>> transformEvents(
      Stream<NewCodeEvent> events,
      TransitionFunction<NewCodeEvent, NewCodeState> transitionFn,
      ) {
    final nonDebounceStream = events.where((event) {
      return (event is! NewCodeModified);
    });
    final debounceStream = events.where((event) {
      return (event is NewCodeModified);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<NewCodeState> mapEventToState(NewCodeEvent event) async* {
    if(event is NewCodeModified) {
      yield* _handleNewCodeModified(event);
    } else if(event is NewCodeSubmit) {
      yield* _handleNewCodeSubmit(event);
    } else if(event is NewCodeNameModified){
      yield* _handleNewCodeNameModified(event);
    } else if(event is NewCodeSeedModified) {
      yield* _handleNewCodeSeedModified(event);
    } else if(event is NewCodeLocalImagePathModified) {
      yield* _handleNewCodeLocalImagePathModified(event);
    }
  }

  Stream<NewCodeState> _handleNewCodeModified(NewCodeModified event) async* {
    Code code = event.code;
    bool isNameValid = false;
    bool isSeedValid = false;
    if(code.name.length > 0 && code.name.length <= 32) { isNameValid = true; }
    if(code.seed.length > 7 && code.seed.length <= 1024 && _validBase32(code.seed)) { isSeedValid = true; }
    yield NewCodeInfo(code: code, isNameValid: isNameValid, isSeedValid: isSeedValid);
  }

  Stream<NewCodeState> _handleNewCodeSubmit(NewCodeSubmit event) async* {
    yield NewCodeLoading(code: event.code);
    Code c = await _processCode(event.code);
    codesBloc.add(CodeAdded(c));
    yield NewCodeCreated();
  }

  Stream<NewCodeState> _handleNewCodeNameModified(NewCodeNameModified event) async* {
    add(NewCodeModified(code: event.code.copyWith(name: event.name)));
  }

  Stream<NewCodeState> _handleNewCodeSeedModified(NewCodeSeedModified event) async* {
    add(NewCodeModified(code: event.code.copyWith(seed: event.seed)));
  }

  Stream<NewCodeState> _handleNewCodeLocalImagePathModified(NewCodeLocalImagePathModified event) async* {
    yield NewCodeLoading(code: event.code.copyWith(localImagePath: null));
    _resizeImage(event.localImagePath);
    add(NewCodeModified(code: event.code.copyWith(localImagePath: event.localImagePath)));
  }

  bool _validBase32(String s) {
    return RegExp(r'^(?:[A-Z2-7]{8})*(?:[A-Z2-7]{2}={6}|[A-Z2-7]{4}={4}|[A-Z2-7]{5}={3}|[A-Z2-7]{7}=)?$').hasMatch(s);
  }

  Future<Code> _processCode(Code c) async {
    if(c.localImagePath == '' || c.localImagePath == null) return c;
    Future<String> newPathFuture = storageRepository.uploadFile(c.localImagePath);
    Future<String> imageBlurhashFuture = genBlurhash(c.localImagePath);
    List<String> results = await Future.wait<String>([newPathFuture, imageBlurhashFuture]);
    c = c.copyWith(localImagePath: '', storageUrl: results[0], blurhash: results[1]);
    return c;
  }

  void _resizeImage(String path) {
    Img.Image image = Img.decodeImage(new Io.File(path).readAsBytesSync());

    Img.Image thumbnail = Img.copyResize(image, width: 200, height: 200);

    new Io.File(path)
      ..writeAsBytesSync(Img.encodePng(thumbnail));
  }

  Future<String> genBlurhash(String filePath) async {
    Uint8List pixels = File(filePath).readAsBytesSync();
    String blurhash = await BlurHash.encode(pixels, 5, 5);
    return blurhash;
  }

}