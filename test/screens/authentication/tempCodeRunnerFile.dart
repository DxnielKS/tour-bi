// testWidgets(
//       'given whenn a user does not input an email but inputs a valid password and tries to log in, an email error text is displayed ',
//       (WidgetTester tester) async {
//     final AuthService authService = AuthService();
//     await tester.pumpWidget(testWidget);
//     final logInbutton = find.byKey(Key('Login Button'));
//     final emailError = find.text('Not a valid email/password');
//     var emailForm = find.byKey(Key("Login Email Key"));
//     var passwordForm = find.byKey(Key("Login Password Key"));
//     await tester.enterText(passwordForm, "NarutoUzumaki123!");
//     await tester.ensureVisible(logInbutton);
//     await tester.tap(logInbutton);
//     await tester.pumpAndSettle();
//     expect(emailError, findsOneWidget);
//   })