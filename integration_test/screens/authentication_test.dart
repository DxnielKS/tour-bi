import 'package:bicycle_hire_app/main.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/screens/authentication/register.dart';
import 'package:bicycle_hire_app/screens/authentication/sign_in.dart';
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/screens/map/MapHome.dart';
import 'package:bicycle_hire_app/services/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';

void main()async{
  AuthService _auth = AuthService();
  _auth.signOut("");
  
  Widget authenticationWidget(){
    return MaterialApp(
      home: Authenticate(auth: _auth),
    );
  }

  Widget authenticationWidget1(){
    GlobalFunctions globalFunctions = GlobalFunctions();
    return MaterialApp(
      home: MyApp(),
    );
  }

  testWidgets("Register and sign in toggle", (WidgetTester tester) async{
    _auth.signOut("");
    await tester.pumpWidget(authenticationWidget());
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key('Switch to Register Button'));
    await tester.tap(signInToggle);
    await tester.pumpAndSettle();
    expect(find.byType(Register), findsOneWidget);
    final registerToggle = find.byKey(Key('Switch to Sign in Button'));
    await tester.tap(registerToggle);
    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
  });

  testWidgets("Register and sign in toggle", (WidgetTester tester) async{
    _auth.signOut("");
    await tester.pumpWidget(authenticationWidget());
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key('Switch to Register Button'));
    await tester.tap(signInToggle);
    await tester.pumpAndSettle();
    expect(find.byType(Register), findsOneWidget);
    //Key('emailfield')
    final signInToggle1 = find.byKey(Key("SignUpButton"));
    await tester.dragUntilVisible(
      signInToggle1, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.tap(signInToggle1);
    await tester.pumpAndSettle();
  });

  testWidgets("Register and sign in toggle", (WidgetTester tester) async{
    _auth.signOut("");
    await tester.pumpWidget(authenticationWidget());
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key('Switch to Register Button'));
    await tester.tap(signInToggle);
    await tester.pumpAndSettle();
    expect(find.byType(Register), findsOneWidget);
    final emailField = find.byKey(Key('emailfield'));
    await tester.enterText(emailField, "example1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final passwordfield = find.byKey(Key('passwordfield'));
    await tester.enterText(passwordfield, "123");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final confirmfield = find.byKey(Key('confirmfield'));
    await tester.enterText(confirmfield, "1234");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final firstnamefield = find.byKey(Key('firstnamefield'));
    await tester.enterText(firstnamefield, "field");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final lastnamefield = find.byKey(Key('lastnamefield'));
    await tester.enterText(lastnamefield, "field");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final agefield = find.byKey(Key('agefield'));
    await tester.enterText(agefield, "12");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    //Key('emailfield')
    final signInToggle1 = find.byKey(Key("SignUpButton"));
    await tester.dragUntilVisible(
      signInToggle1, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.tap(signInToggle1);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
  });

  testWidgets("Register and sign in toggle", (WidgetTester tester) async{
    _auth.signOut("");
    await tester.pumpWidget(authenticationWidget());
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key('Switch to Register Button'));
    await tester.tap(signInToggle);
    await tester.pumpAndSettle();
    expect(find.byType(Register), findsOneWidget);
    final emailField = find.byKey(Key('emailfield'));
    await tester.enterText(emailField, "example1@example.com");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final passwordfield = find.byKey(Key('passwordfield'));
    await tester.enterText(passwordfield, "Taz123!");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final confirmfield = find.byKey(Key('confirmfield'));
    await tester.enterText(confirmfield, "Taz123!");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final firstnamefield = find.byKey(Key('firstnamefield'));
    await tester.enterText(firstnamefield, "Name");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final lastnamefield = find.byKey(Key('lastnamefield'));
    await tester.enterText(lastnamefield, "Example");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final agefield = find.byKey(Key('agefield'));
    await tester.enterText(agefield, "19");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    //Key('emailfield')
    final signInToggle1 = find.byKey(Key("SignUpButton"));
    await tester.dragUntilVisible(
      signInToggle1, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.tap(signInToggle1);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
  });

  testWidgets("sign in as guest", (WidgetTester tester) async{
    _auth.signOut("");
    await tester.pumpWidget(authenticationWidget1());
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key("Guest Login key"));
    await tester.enterText(signInToggle, "example1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('example1'), findsOneWidget);
    final signInToggle1 = find.byKey(Key('Guest Login Button'));
    await tester.dragUntilVisible(
      signInToggle1, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.tap(signInToggle1);
    await tester.pumpAndSettle();
    expect(find.byType(IntroductionScreen), findsOneWidget);
    final skip = find.text("Skip");
    expect(skip, findsOneWidget);
    await tester.tap(skip);
    await tester.pumpAndSettle();
    final done = find.text("Done");
    expect(done, findsOneWidget);
    await tester.tap(done);
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
  });

  // testWidgets("sign in", (WidgetTester tester) async{
  //   _auth.signOut("");
  //   await tester.pumpWidget(authenticationWidget());
  //   await tester.pumpAndSettle();
  //   final emailField = find.byKey(Key("Login Email Key"));
  //   await tester.enterText(emailField, "example1@example.com");
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.pump();
  //   final passwordfield = find.byKey(Key("Login Password Key"));
  //   await tester.enterText(passwordfield, "Taz123!");
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.pump();
  //   //Key('emailfield')
  //   final signInToggle1 = find.byKey(Key('Login Button'));
  //   await tester.dragUntilVisible(
  //     signInToggle1, // what you want to find
  //     find.byType(SingleChildScrollView), // widget you want to scroll
  //     const Offset(0, 50), // delta to move
  //   );
  //   await tester.tap(signInToggle1);
  //   await tester.pumpAndSettle();
  //   _auth.signOut("");
  // });

  
}