import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/groups/groupAuth/group_provider.dart';
import 'package:bicycle_hire_app/screens/sidebar/provider_drawer.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  AuthService _auth = AuthService();

  Widget drawerWidget() {
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

  testWidgets("Tap on Groups", (WidgetTester tester) async{
    await tester.pumpWidget(drawerWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    var groups = find.byIcon(Icons.group);
    await tester.pumpAndSettle();
    await tester.tap(groups);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), "Group1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(find.text("Create"));
    await tester.pumpAndSettle();
    expect(find.byType(GroupProvider), findsOneWidget);
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.text("You"));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text("Leave Group"));
    await tester.tap(find.text("Leave Group"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 4));
  });



  testWidgets("Tap on Groups", (WidgetTester tester) async{
    AuthService _auth = AuthService();
    var data = DatabaseService(uid: _auth.getCurrent()?.uid);
    var groupId = "";
    await data.createGroup("joinGroupExample");
    await data.getcurrentUser().then((value) async {
      print(value["groupId"]);
      groupId = await value["groupId"];
    });
    var group_example = await data.groupCollection.doc(groupId).get();
    var code = group_example["JoinCode"];
    print(group_example.data());
    await _auth.signOut("");
    Account? account = await _auth.signInAnon("zane");
    await tester.pumpWidget(drawerWidget());
    await tester.pump();
    await tester.pumpAndSettle();
    var groups = find.byIcon(Icons.group);
    await tester.pumpAndSettle();
    await tester.tap(groups);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), code);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.text("Join"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Test0"));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await _auth.signOut("");
    await Future.delayed(Duration(seconds: 2));
    await _auth.LogInWithEmail("test0@example.org", "Password123!");
  });
}