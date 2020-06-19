import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:lockie/blocs/authentication_bloc/bloc.dart';
import 'package:lockie/blocs/codes_bloc/bloc.dart';
import 'package:lockie/blocs/codes_bloc/codes_bloc.dart';
import 'package:lockie/models/user.dart';
import 'package:lockie/repositories/codes_repository.dart';
import 'package:lockie/screens/constants.dart';
import 'package:lockie/screens/create_code/create_code.dart';

import 'codes_body.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class CodesScreen extends StatelessWidget {

  final User user;

  CodesScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CodesBloc(codesRepository: CodesRepository(uid: user.uid))..add(LoadCodes()),
      child: Scaffold(
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
        actions: [
          FlatButton(
            color: kBackgroundColor,
            child: Icon(
              Icons.exit_to_app,
              color: kPrimaryColor,
            ),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: CodesBody(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: kIsWeb ? null : Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCodeScreen(uid: user.uid))),
          child: Icon(Icons.add),
        ),
      ),
    )
    );
  }
}
