
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/profile/edit_login_details.dart';
import 'package:bicycle_hire_app/screens/profile/edit_profile.dart';
import 'package:bicycle_hire_app/screens/profile/profile.dart';
import 'package:bicycle_hire_app/screens/profile/profile_stream.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';

void main() async{
  AuthService _auth = AuthService();


  // Widget profileWidget(){
  //   return MaterialApp(
  //     home: ProfileProvider(memberUid: _auth.getCurrent()?.uid as String)
  //   );
  // }

  Widget profileWidget(){
    return MaterialApp(
      home: ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: StreamProvider<Account?>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            home: ProfileProvider(memberUid: _auth.getCurrent()?.uid as String),
          )),
    ));
  }

  testWidgets("Edit profile", (WidgetTester tester) async{
    await tester.pumpWidget(profileWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("Edit profile button")));
    await tester.pumpAndSettle();
    expect(find.byType(editProfile), findsOneWidget);
    var firstNameField = find.byKey(Key("Edit profile first name"));
    var surnameField = find.byKey(Key("Edit profile surname"));
    var ageField = find.byKey(Key("Edit profile age"));
    var saveButton = find.byKey(Key("Edit profile save button"));
    await tester.enterText(firstNameField, "Test");
    await tester.pumpAndSettle();
    await tester.enterText(surnameField, "Example");
    await tester.pumpAndSettle();
    await tester.enterText(ageField, "22");
    await tester.pumpAndSettle();
    //await tester.ensureVisible(saveButton);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Edit Profile"));
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.byType(editProfile), findsNothing);
    expect(find.byType(ViewProfile), findsOneWidget);
  });

  testWidgets("Edit log in details", (WidgetTester tester) async{
    await tester.pumpWidget(profileWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("Edit log in details button")));
    await tester.pumpAndSettle();
    var editLogInPassword = find.byKey(Key("Edit log in Enter password"));
    await tester.enterText(editLogInPassword, "Password123!");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    expect(find.byType(editLoginDetails), findsOneWidget);
    var emailField = find.byKey(Key("Edit profile new email"));
    var emailButton = find.byKey(Key("Edit profile change email button"));
    var passwordField = find.byKey(Key("Edit profile new password"));
    var passwordConfirmationField = find.byKey(Key("Edit profile new password confirmation"));
    var passwordButton = find.byKey(Key("Edit profile change password button"));
    await tester.enterText(emailField, "test0@example.com");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(emailButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    expect(find.byType(editLoginDetails), findsOneWidget);
    await tester.enterText(passwordField, "Taz123!");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.enterText(passwordConfirmationField, "Taz123!");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(passwordButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
  });

}
