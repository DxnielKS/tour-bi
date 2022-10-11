import 'dart:async';
import 'dart:math';

import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/authentication/register.dart';
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/screens/introPage/intro_screen.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/screens/wrapper.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../firebaseMock.dart';
import 'logIn_test.mocks.dart';
import 'register_test.mocks.dart';

// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() async {
  StreamController<Account?> controller = StreamController();
  MockAuthService _auth = MockAuthService();
  bool showSignIn = true;
  MockglobalFunctions globalfunctions = MockglobalFunctions();
  when(globalfunctions.getIsNewUser()).thenAnswer((realInvocation) async {
    return true;
  });

  void toggleView() {
    showSignIn = !(showSignIn);
  }

  Account firstUser = Account(uid: "123", firstName: 'John', inGroup: false);

  when(_auth.user).thenAnswer((realInvocation) {
    // print("This runs");
    return Stream.fromIterable([firstUser]);
  });
  when(_auth.CreateAccount(
          'test@example.com', 'Password123!', 'John', 'Doe', '25'))
      .thenAnswer((realInvocation) async {
    // print("new User is added");
    return controller.add(firstUser);
  });
  Widget testWidget2 = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
          home: new introScreen(globalFunctions: globalfunctions)));
  Widget testWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
          home: new Wrapper(
        auth: _auth,
        globalFunctions: globalfunctions,
      )));
  ;
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  testWidgets("Intro page works", (WidgetTester tester) async {
    await tester.pumpWidget(testWidget2);
    await globalfunctions.getIsNewUser();
    await tester.pump();
  });
  testWidgets(
      "Given a user is on register page when user submits form without inputing an email then an email error text is displayed",
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    final SignUpbutton = find.widgetWithText(ElevatedButton, 'Register');
    final emailError = find.text('enter a valid email');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(emailError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form without inputing an password then an password error text is displayed",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    final SignUpbutton = find.byType(ElevatedButton);
    final passwordError = find.text(
        'enter a password with 6 or more characters, one symbol and a capital letter');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(passwordError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form without inputing a first name and surname then an name error text is displayed",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    final SignUpbutton = find.byType(ElevatedButton);
    final firstNameError = find.text('enter a name');
    final lastNameEroor = find.text('enter a name');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(firstNameError, findsWidgets);
    expect(lastNameEroor, findsWidgets);
  });
  testWidgets(
      "Given a user is on register page when user submits form without inputing an age then an age error text is displayed",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    final SignUpbutton = find.byType(ElevatedButton);
    final ageError = find.text('You need to be 18 or older to continue..');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(ageError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form with a too young age, it will display a message stating this",
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    var txtform = find.byKey(Key('agefield'));
    final SignUpbutton = find.byType(ElevatedButton);
    final ageError = find.text('You need to be 18 or older to continue..');
    await tester.enterText(txtform, '17');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(ageError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form with a too incorrent email, it will display a message stating this",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    var txtForm = find.byKey(Key('emailfield'));
    final SignUpbutton = find.byType(ElevatedButton);
    final emailError = find.text('enter a valid email');
    await tester.enterText(txtForm, 'fakemail.com');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(emailError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form with a not valid password then an password error text is displayed",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
    await tester.pumpWidget(testWidget);
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    var txtForm = find.byKey(Key('passwordfield'));
    final SignUpbutton = find.byType(ElevatedButton);
    final passwordError = find.text(
        'enter a password with 6 or more characters, one symbol and a capital letter');
    await tester.enterText(txtForm, '12');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pumpAndSettle();
    expect(passwordError, findsOneWidget);
  });
  testWidgets(
      "Given a user is on register page when user submits form with a all valid forms then the intro page is displayed.",
      (WidgetTester tester) async {
    final AuthService authService = AuthService();
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
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  // buttonColor: Colors.blue,
                )),
          )),
    ));
    await tester.tap(find.byKey(Key("Switch to Register Button")));
    await tester.pumpAndSettle();
    var txtFormone = find.byKey(Key('emailfield'));
    var txtFormtwo = find.byKey(Key('passwordfield'));
    var txtformthree = find.byKey(Key('firstnamefield'));
    var txtformfour = find.byKey(Key('lastnamefield'));
    var txtFormfive = find.byKey(Key('agefield'));
    var txtFormSix = find.byKey(Key('confirmfield'));
    final SignUpbutton = find.byType(ElevatedButton);
    await tester.enterText(txtFormone, 'test@example.com');
    await tester.enterText(txtFormtwo, 'Password123!');
    await tester.enterText(txtFormSix, 'Password123!');
    await tester.enterText(txtformthree, 'John');
    await tester.enterText(txtformfour, 'Doe');
    await tester.enterText(txtFormfive, '25');
    await tester.ensureVisible(SignUpbutton);
    await tester.tap(SignUpbutton);
    await tester.pump();
    await tester.pump();
    expect(find.text("Welcome to TourBi"), findsOneWidget);
  });
}
