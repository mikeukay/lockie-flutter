import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lockie/blocs/codes_bloc/bloc.dart';
import 'package:lockie/blocs/new_code_bloc/new_code_bloc.dart';
import 'package:lockie/blocs/new_code_bloc/new_code_event.dart';
import 'package:lockie/blocs/new_code_bloc/new_code_state.dart';
import 'package:lockie/models/code.dart';
import 'package:lockie/repositories/codes_repository.dart';
import 'package:lockie/repositories/storage_repository.dart';
import 'package:lockie/screens/constants.dart';

import 'qr.dart';

class CreateCodeScreen extends StatelessWidget {

  final String uid;
  final NewCodeBloc newCodeBloc;

  final _seedController = TextEditingController();

  CreateCodeScreen({this.uid}) : newCodeBloc = NewCodeBloc(codesBloc: CodesBloc(codesRepository: CodesRepository(uid: uid)), storageRepository: StorageRepository(uid: uid));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewCodeBloc, NewCodeState>(
          bloc: newCodeBloc,
          builder: (context, state) {
            if(state is NewCodeCreated) {
              return PopContextWidget();
            }

            if(state is NewCodeLoading || state is NewCodeInfo || state is NewCodeInitial) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Lockie'.toUpperCase(),
                      style: TextStyle(
                        color: kPrimaryColor,
                        letterSpacing: 2.0,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                  floatingActionButton: state is NewCodeLoading ? null : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        if(state.isSeedValid && state.isNameValid) {
                          newCodeBloc.add(NewCodeSubmit(code: state.code));
                        }
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  body: Column(
                     mainAxisSize: MainAxisSize.max,
                    children: [
                      buildImagePicker(state),
                      buildWhitePart(state),
                    ],
                  ),
              );
            }

            return Center(
              child: Text(
                'wtf?!?'
              ));
          }
      );
  }

  Widget buildImagePicker(NewCodeState state) {
    Code c = state.code;
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: c.localImagePath == null ? AssetImage('assets/images/default.png') :  FileImage(File(c.localImagePath)),
            )
          ),
        ),
        SizedBox(height: 16),
        FlatButton.icon(
          icon: Icon(
            Icons.edit,
            color: kBackgroundColor,
          ),
          label: Text(
            'Select new picture',
            style: TextStyle(color: kBackgroundColor),
          ),
          color: state is NewCodeLoading ? kCommentColor : kPrimaryColor,
          onPressed: state is NewCodeLoading ? () {} : () async {
            final picker = ImagePicker();
            final pickedFile = await picker.getImage(source: ImageSource.gallery);
            newCodeBloc.add(NewCodeLocalImagePathModified(localImagePath: pickedFile.path, code: c));
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildWhitePart(NewCodeState state) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: state is NewCodeLoading ? Center(child: CircularProgressIndicator()) : Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                      color: kBackgroundColor,
                      decoration: TextDecoration.none
                  ),
                  initialValue: state.code.name,
                  validator: (_) {
                    if(state is NewCodeInitial) {
                      return null;
                    }
                    return state.code.name != "" && !state.isNameValid ? 'Invalid Name' : null;
                  },
                  autovalidate: true,
                  autocorrect: false,
                  maxLength: 32,
                  decoration: kInputDecorationRev.copyWith(
                      labelText: 'Name',
                      hintText: 'e.g. NameCheap Main Account',
                  ),
                  onChanged: (newVal) {
                    newCodeBloc.add(NewCodeNameModified(name: newVal, code: state.code));
                  },
                ),
                Row(
                  children: [
                      Expanded(
                        child: TextFormField(
                          controller: _seedController,
                        style: TextStyle(
                           color: kBackgroundColor,
                            decoration: TextDecoration.none
                       ),
                        validator: (_) {
                         if(state is NewCodeInitial) {
                            return null;
                          }
                          return state.code.seed != "" && !state.isSeedValid ? 'Invalid Seed' : null;
                        },
                        autovalidate: true,
                        autocorrect: false,
                        maxLength: 1024,
                       decoration: kInputDecorationRev.copyWith(
                          labelText: 'Seed',
                          hintText: 'e.g. I184AB',
                        ),
                        onChanged: (newVal) {
                           newCodeBloc.add(NewCodeSeedModified(seed: newVal, code: state.code));
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: kBackgroundColor,
                      onPressed: () async {
                        String newSeed = await getSeedFromQR();
                        _seedController.text = newSeed;
                        newCodeBloc.add(NewCodeSeedModified(seed: newSeed, code: state.code));
                      },
                    ),
                  ],
                ),
              ]
            ),
          )
        ),
      ),
    );
  }
}


class PopContextWidget extends StatefulWidget {
  @override
  _PopContextWidgetState createState() => _PopContextWidgetState();
}

class _PopContextWidgetState extends State<PopContextWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
