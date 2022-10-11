import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/screens/authentication/register.dart';
import 'package:bicycle_hire_app/screens/authentication/sign_in.dart';

class Authenticate extends StatefulWidget {
  AuthService auth;
  Authenticate({required this.auth});
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(
        toggleView: toggleView,
        auth: widget.auth,
      );
    } else {
      return Register(
        toggleView: toggleView,
        auth: widget.auth,
      );
    }
  }
}
