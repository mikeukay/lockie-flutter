import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/authentication_bloc/bloc.dart';
import 'package:lockie/blocs/register_bloc/bloc.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/components/signup_button.dart';
import 'package:lockie/screens/authenticate/login_screen.dart';
import 'package:lockie/screens/constants.dart';

import '../shared/logo.dart';

class RegisterBody extends StatefulWidget {

  final UserRepository userRepository;

  RegisterBody({this.userRepository});

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;
  UserRepository get _userRepository => widget.userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
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
          'Sign Up',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Sign Up Failure'), Icon(Icons.error)],
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
                      Text('Signing Up...'),
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
        child: BlocBuilder<RegisterBloc, RegisterState>(
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
                        'for',
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
                                SignUpButton(onTap: () => _onFormSubmitted(state)),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    InkWell(
                                      child: Text(
                                        'Login.',
                                        style: TextStyle(fontSize: 16.0,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(userRepository: _userRepository)));
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
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted(RegisterState state) {
    if(isRegisterButtonEnabled(state)) {
      _registerBloc.add(
        RegisterSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
