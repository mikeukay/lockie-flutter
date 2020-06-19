import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:lockie/blocs/authentication_bloc/authentication_event.dart';
import 'package:lockie/blocs/authentication_bloc/authentication_state.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/authenticate.dart';
import 'package:lockie/screens/codes/codes.dart';
import 'package:lockie/screens/constants.dart';
import 'package:lockie/screens/splash/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserRepository userRepository = new UserRepository();
  runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted()),
        child: App(userRepository: userRepository),
      )
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lockie',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        splashColor: kCommentColor,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        appBarTheme: AppBarTheme(
          color: kBackgroundColor,
          iconTheme: IconThemeData(color: kPrimaryColor),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: kPrimaryColor),
            bodyText2: TextStyle(color: kPrimaryColor),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kPrimaryColor),
          bodyText2: TextStyle(color: kPrimaryColor),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is AuthenticationInitial) {
            return SplashScreen();
          } else if(state is AuthenticationSuccess) {
            return CodesScreen(user: state.user);
          } else {
            return AuthenticateScreen(userRepository: userRepository);
          }
        },
      ),
    );
  }
}
