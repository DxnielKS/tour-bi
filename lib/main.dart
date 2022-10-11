import 'dart:io';
import 'package:bicycle_hire_app/services/authHelpers/firebase_options.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/screens/wrapper.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GlobalFunctions globalFunctions = GlobalFunctions();
  AuthService _auth = AuthService();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: StreamProvider<Account?>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper(
              globalFunctions: globalFunctions,
              auth: _auth,
            ),
            theme: ThemeData(
              //2
                primaryColor: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Montserrat', //3
                buttonTheme: ButtonThemeData(
                  // 4
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  // buttonColor: Colors.blue,
                )),
          )),
    );
  }
//canvasColor: Color.fromARGB(255, 13, 33, 161),
}
