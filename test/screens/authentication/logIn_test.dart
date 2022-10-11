import 'dart:async';

import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/authentication/register.dart';
import 'package:bicycle_hire_app/screens/authentication/sign_in.dart';
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/screens/wrapper.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../firebaseMock.dart';
import 'logIn_test.mocks.dart';
import 'register_test.mocks.dart';

void main() async {
  StreamController<Account?> controller = StreamController();
  StreamController<Account?> controller2 = StreamController();
  TestWidgetsFlutterBinding.ensureInitialized();
  bool showSignIn = true;
  MockglobalFunctions globalfunctions = MockglobalFunctions();
  MockAuthService _auth = MockAuthService();
  Account firstUser = Account(uid: "12345", firstName: "John", inGroup: false);
  Account _anonUser =
      Account(uid: "1234", inGroup: false, firstName: "JohnDoe");
  when(_auth.signInAnon("JohnDoe")).thenAnswer(
    (realInvocation) async {
      controller.add(_anonUser);
    },
  );
  when(_auth.LogInWithEmail("test123@example.com", "Password123!")).thenAnswer(
    (realInvocation) async {
      controller2.add(firstUser);
    },
  );
  when(_auth.LogInWithEmail("test@example.com", "Password123!")).thenAnswer(
    (realInvocation) async {
      return null;
    },
  );
  void toggleView() {
    showSignIn = !(showSignIn);
  }

  Widget testWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
          home: new SignIn(
        auth: _auth,
        toggleView: toggleView,
      )));
  Widget testWidgettwo = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
          home: new Wrapper(
        auth: _auth,
        globalFunctions: globalfunctions,
      )));
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  const bool USE_EMULATOR = true;

  if (USE_EMULATOR) {
    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  // [Authentication | localhost:9099]
  //await auth.useAuthEmulator('localhost', 9099);
  testWidgets(
      'given whenn a user does not input an email but inputs a valid password and tries to log in, an email error text is displayed ',
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    final logInbutton = find.byKey(Key('Login Button'));
    final emailError = find.text('Not a valid email/password');
    var emailForm = find.byKey(Key("Login Email Key"));
    var passwordForm = find.byKey(Key("Login Password Key"));
    await tester.enterText(passwordForm, "NarutoUzumaki123!");
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pumpAndSettle();
    expect(emailError, findsOneWidget);
  });
  testWidgets(
      'given when a user does not input a password and tries to log in a password  error text is displayed ',
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    var usernameForm = find.byKey(Key("Login Email Key"));
    final logInbutton = find.byKey(Key('Login Button'));
    final passwordError = find.text('Not a valid email/password');
    await tester.enterText(usernameForm, "dawudOsman@gmail.com");
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(passwordError, findsOneWidget);
  });
  testWidgets(
      'Given when a user tries to anonymously sign in with no name in the nickname box, an error message is displayed .',
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    final logInbutton = find.byKey(Key('Guest Login Button'));
    final guestError = find.text('need a nickname');
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(guestError, findsOneWidget);
  });
  testWidgets(
      'Given when a user inputs an email and password that isnt saved in the database an not valid email/password test is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    final logInbutton = find.byKey(Key('Login Button'));
    final emailError = find.text('Not a valid email/password');
    var emailForm = find.byKey(Key("Login Email Key"));
    var passwordForm = find.byKey(Key("Login Password Key"));
    await tester.enterText(emailForm, "test@example.com");
    await tester.enterText(passwordForm, "Password123!");
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pumpAndSettle();
    expect(emailError, findsOneWidget);
  });
  testWidgets(
      "Given when a user enters a guest nickname, the intro page will be displayed",
      ((WidgetTester tester) async {
    when(globalfunctions.getIsNewUser()).thenAnswer((realInvocation) async {
      return true;
    });
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: StreamProvider<Account?>.value(
          value: controller.stream,
          initialData: null,
          child: MaterialApp(
            home: Wrapper(
              globalFunctions: globalfunctions,
              auth: _auth,
            ),
            theme: ThemeData(
                //2
                primaryColor: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Montserrat', //3
                buttonTheme: ButtonThemeData(
                  // 4
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  // buttonColor: Colors.blue,
                )),
          )),
    ));
    final logInbutton = find.byKey(Key('Guest Login Button'));
    var guestForm = find.byKey(Key("Guest Login key"));
    await tester.enterText(guestForm, "JohnDoe");
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pump();
    await tester.pump();
    expect(find.text("Welcome to TourBi"), findsOneWidget);
  }));
  testWidgets(
      "Given when a user correctly inputs an email and password that is saved in the database, permission page is displayed",
      ((WidgetTester tester) async {
    when(globalfunctions.getIsNewUser()).thenAnswer((realInvocation) async {
      return false;
    });
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: StreamProvider<Account?>.value(
          value: controller2.stream,
          initialData: null,
          child: MaterialApp(
            home: Wrapper(
              globalFunctions: globalfunctions,
              auth: _auth,
            ),
            theme: ThemeData(
                //2
                primaryColor: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Montserrat', //3
                buttonTheme: ButtonThemeData(
                  // 4
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  // buttonColor: Colors.blue,
                )),
          )),
    ));
    final logInbutton = find.byKey(Key('Login Button'));
    var emailForm = find.byKey(Key("Login Email Key"));
    var passwordForm = find.byKey(Key("Login Password Key"));
    await tester.enterText(emailForm, "test123@example.com");
    await tester.enterText(passwordForm, "Password123!");
    await tester.ensureVisible(logInbutton);
    await tester.tap(logInbutton);
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(
        find.text("To use this app you will need\n"
            "to go to settings and enable\n"
            "Location to 'Always'\n\n"
            "You may need to restart the\n"
            "app."),
        findsWidgets);
  }));
  //testWidgets(
  //'given when a user inputs an email and password that isnt saved in the database  an not valid email/password text is displayed',
  //(WidgetTester tester) async {
  //final AuthService authService = AuthService();
  //await tester.pumpWidget(testWidget);
  //final logInError = find.byKey(Key("errorDisplay"));
  //var emailForm = find.byKey(Key('emailField'));
  //var passwordForm = find.byKey(Key('passwordField'));
  //final logInbutton = find.byType(ElevatedButton);
  //await tester.enterText(emailForm, 'dawudosman@example.com');
  //await tester.enterText(passwordForm, 'NarutoUzumaki123!');
  //await tester.tap(logInbutton);
  //for (int i = 0; i < 20; i++) {
  // because pumpAndSettle doesn't work with riverpod
  //await tester.pump(Duration(seconds: 20));
  //}
  //expect(find.text('Not a valid email/password'), findsOneWidget);
  //});
  //testWidgets(
  //'given when a user inputs an email and password that is saved in the database  user is directed to home page',
  //WidgetTester tester) async {
  //final AuthService authService = AuthService();
  //var user = MockUser(email: 'tazRahman@gmail.com');
  //var newuser = mockAuthService().CreateAccount(
  //'tazRahman@gmail.com', 'narutoUzumaki123!', 'taz', 'rahman', '20');
  //await tester.pumpWidget(testWidgettwo);
  //final logInError = find.byKey(Key("errorDisplay"));
  //var emailForm = find.byKey(Key('emailField'));
  //var passwordForm = find.byKey(Key('passwordField'));
  //final logInbutton = find.byType(ElevatedButton);
  //await tester.enterText(emailForm, 'tazRahman@gmail.com');
  //await tester.enterText(passwordForm, 'narutoUzumaki123!');
  //await tester.tap(logInbutton);
  //for (int i = 0; i < 20; i++) {
  // because pumpAndSettle doesn't work with riverpod
  //await tester.pump(Duration(seconds: 20));
  //}
  //expect(find.text('Not a valid email/password'), findsOneWidget);
  //});
}
