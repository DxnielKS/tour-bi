import 'dart:async';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/getStarted/get_started.dart';
import 'package:bicycle_hire_app/screens/profile/profile_stream.dart';
import 'package:bicycle_hire_app/screens/sidebar/provider_drawer.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';

void main() async{
  AuthService _auth = AuthService();

  Widget drawerWidget(){
    return MaterialApp(
      home: ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: StreamProvider<Account?>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            home: DrawerProvider(),
          )),
    ));
  }

  // testWidgets("Edit profile", (WidgetTester tester) async{
  //   await tester.pumpWidget(profileWidget());
  //   await tester.pump();
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byKey(Key("Edit profile button")));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(editProfile), findsOneWidget);
  //   var firstNameField = find.byKey(Key("Edit profile first name"));
  //   var surnameField = find.byKey(Key("Edit profile surname"));
  //   var ageField = find.byKey(Key("Edit profile age"));
  //   var saveButton = find.byKey(Key("Edit profile save button"));
  //   await tester.enterText(firstNameField, "Test");
  //   await tester.pumpAndSettle();
  //   await tester.enterText(surnameField, "Example");
  //   await tester.pumpAndSettle();
  //   await tester.enterText(ageField, "22");
  //   await tester.pumpAndSettle();
  //   //await tester.ensureVisible(saveButton);
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text("Edit Profile"));
  //   await tester.pumpAndSettle();
  //   await tester.tap(saveButton);
  //   await tester.pumpAndSettle();
  //   expect(find.byType(editProfile), findsNothing);
  //   expect(find.byType(ViewProfile), findsOneWidget);
  // });

  // testWidgets("Edit log in details", (WidgetTester tester) async{
  //   await tester.pumpWidget(profileWidget());
  //   await tester.pump();
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byKey(Key("Edit log in details button")));
  //   await tester.pumpAndSettle();
  //   var editLogInPassword = find.byKey(Key("Edit log in Enter password"));
  //   await tester.enterText(editLogInPassword, "Password123!");
  //   await tester.pumpAndSettle();
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text("error"));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(editLoginDetails), findsOneWidget);
  //   var emailField = find.byKey(Key("Edit profile new email"));
  //   var emailButton = find.byKey(Key("Edit profile change email button"));
  //   var passwordField = find.byKey(Key("Edit profile new password"));
  //   var passwordConfirmationField = find.byKey(Key("Edit profile new password confirmation"));
  //   var passwordButton = find.byKey(Key("Edit profile change password button"));
  //   await tester.enterText(emailField, "test0@example.org");
  //   await tester.pumpAndSettle();
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.tap(emailButton);
  //   await tester.pumpAndSettle();
  //   expect(find.byType(editLoginDetails), findsOneWidget);
  //   await tester.enterText(passwordField, "Password123!");
  //   await tester.pumpAndSettle();
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.enterText(passwordConfirmationField, "Password123!");
  //   await tester.pumpAndSettle();
  //   await tester.testTextInput.receiveAction(TextInputAction.done);
  //   await tester.tap(passwordButton);
  //   await tester.pumpAndSettle();
  //   expect(find.byType(editLoginDetails), findsOneWidget);
  // });

  

  testWidgets("Tap on Get started", (WidgetTester tester) async{
    await tester.pumpWidget(drawerWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    var getStarted = find.byIcon(Icons.school);
    await tester.pumpAndSettle();
    await tester.tap(getStarted);
    await tester.pumpAndSettle();
    expect(find.byType(GetStarted), findsOneWidget);
  });

  testWidgets("Tap on Profile", (WidgetTester tester) async{
    await tester.pumpWidget(drawerWidget());
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
    var profile = find.byIcon(Icons.account_circle);
    await tester.pumpAndSettle();
    await tester.tap(profile);
    await tester.pumpAndSettle();
    expect(find.byType(ProfileProvider), findsOneWidget);
  });


  testWidgets("Tap on Groups", (WidgetTester tester) async{
    await tester.pumpWidget(drawerWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    var groups = find.byIcon(Icons.group);
    await tester.pumpAndSettle();
    await tester.tap(groups);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 4));
  });


  //
  // testWidgets("Tap on Log out", (WidgetTester tester) async{
  //   await tester.pumpWidget(drawerWidget());
  //   await tester.pump();
  //   await tester.pumpAndSettle();
  //   var logOut = find.byIcon(Icons.logout);
  //   await tester.pumpAndSettle();
  //   await tester.tap(logOut);
  //   await tester.pump();
  //   await tester.pumpAndSettle();
  //   expect(find.byType(Authenticate), findsOneWidget);
  //   await _auth.LogInWithEmail("test0@example.org", "Password123!");
  // });
}
