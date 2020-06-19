import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lockie/blocs/authentication_bloc/bloc.dart';
import 'package:lockie/blocs/login_bloc/bloc.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/components/login_button.dart';
import 'package:lockie/screens/authenticate/components/orseparator.dart';
import 'package:lockie/screens/constants.dart';

import '../shared/logo.dart';
import 'register_screen.dart';

class LoginBody extends StatefulWidget {

  final UserRepository userRepository;

  LoginBody({this.userRepository});

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget.userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Login Failure'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logging In...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                width: width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - AppBar().preferredSize.height - 50.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'to',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    Logo(),
                    SizedBox(height: 42.0),
                    Expanded(
                      child: Container(
                        width: width * 0.75 > 500.0 ? 500.0 : width * 0.75,
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Spacer(),
                              TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: kPrimaryColor),
                                validator: (_) {
                                  return !state.isEmailValid ? 'Invalid Email' : null;
                                },
                                autovalidate: true,
                                autocorrect: false,
                                decoration: kInputDecoration.copyWith(
                                    hintText: 'Email'
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(color: kPrimaryColor),
                                validator: (_) {
                                  return !state.isPasswordValid ? 'Invalid Password' : null;
                                },
                                autovalidate: true,
                                autocorrect: false,
                                decoration: kInputDecoration.copyWith(
                                    hintText: 'Password'
                                ),
                              ),
                              Spacer(flex: 2),
                              LogInButton(onTap: () => _onFormSubmitted(state)),
                              OrSeparator(),
                              RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                 ),
                                icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                                onPressed: () {
                                  BlocProvider.of<LoginBloc>(context).add(
                                   LoginWithGooglePressed(),
                                  );
                                  },
                                label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                                color: Colors.redAccent,
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account? ',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Register.',
                                      style: TextStyle(fontSize: 16.0,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(userRepository: _userRepository)));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted(LoginState state) {
    if(isLoginButtonEnabled(state)) {
      _loginBloc.add(
        LoginWithCredentialsPressed(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
