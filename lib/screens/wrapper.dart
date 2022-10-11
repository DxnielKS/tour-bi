import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/authentication/sign_in.dart';
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/screens/map/MapHome.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'introPage/intro_screen.dart';

class Wrapper extends StatelessWidget {
  GlobalFunctions globalFunctions;
  AuthService auth;
  Wrapper({Key? key, required this.globalFunctions, required this.auth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account?>(context);
    //final AnonUser provider
    
    if (user == null) {
      //or anonuser is not null
      // if the user is not logged in
      return Authenticate(
        auth: auth,
      );
    } else {
      // if the user is logged in
      return introScreen(
        globalFunctions: globalFunctions,
      );
    }
  }
}
