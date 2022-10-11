import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_data/mock_data.dart';

import '../database_mock_service.dart';
import '../mock_data.dart';

Future<void> main() async {
  mockSetup();

  group("Groups tests", () {
    test("Create a group", () async {
      final user = getMockUser();
      MockFirebaseAuth _auth = MockFirebaseAuth();
      await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: "Password123!");
      await _auth.signInWithEmailAndPassword(
          email: user.email!, password: "Password123!");
      DatabaseMockService database =
      DatabaseMockService(uid: _auth.currentUser?.uid);

      var groupId = "";

      await database.updateUserData(mockName(), mockName(), "19", "", false, 0);

      await database.createGroup("GroupExample");

      await database.getcurrentUser().then((value) async {
        groupId = await value["groupId"];
      });

      var group_doc =
      await database.firestore.collection("groups").doc(groupId).get();

      expect(group_doc.data() != null, true);
    });

    test("Create a group then disband the group", () async {
      final user = getMockUser();
      MockFirebaseAuth _auth = MockFirebaseAuth();
      await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: "Password123!");
      await _auth.signInWithEmailAndPassword(
          email: user.email!, password: "Password123!");
      DatabaseMockService database =
      DatabaseMockService(uid: _auth.currentUser?.uid);

      var groupId = "";

      await database.updateUserData(mockName(), mockName(), "19", "", false, 0);

      await database.createGroup("GroupExample");

      await database.getcurrentUser().then((value) async {
        groupId = await value["groupId"];
      });

      var group_doc =
      await database.firestore.collection("groups").doc(groupId).get();

      List<dynamic> group_length = group_doc["listOfUsers"];

      expect(group_length.length, 1);

      await database.disbandGroup(groupId);

      group_doc =
      await database.firestore.collection("groups").doc(groupId).get();
      expect(group_doc.data(), null);
    });

    test("Create a group with one user and then join group with another user",
            () async {
          final user = getMockUser();
          MockFirebaseAuth _auth = MockFirebaseAuth();
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: "Password123!");
          await _auth.signInWithEmailAndPassword(
              email: user.email!, password: "Password123!");
          DatabaseMockService database =
          DatabaseMockService(uid: _auth.currentUser?.uid);

          var groupId = "";
          var code = "";

          await database.updateUserData(mockName(), mockName(), "19", "", false, 0);

          await database.createGroup("GroupExample");

          await database.getcurrentUser().then((value) async {
            groupId = await value["groupId"];
          });

          var group_doc =
          await database.firestore.collection("groups").doc(groupId).get();

          List<dynamic> group_length = group_doc["listOfUsers"];

          expect(group_length.length, 1);

          code = await group_doc["JoinCode"];

          _auth.signOut();

          await mockSignInAnon(user);

          final auth = MockFirebaseAuth(mockUser: user);
          await auth.signInAnonymously();

          var uidChange = auth.currentUser?.uid;
          await database.changeUid(uidChange!);

          await database.updateUserData(mockName(), mockName(), "19", "", true, 0);

          await database.addUserToGroup(code);
          group_doc =
          await database.firestore.collection("groups").doc(groupId).get();

          group_length = group_doc["listOfUsers"];

          expect(group_length.length, 2);
        });
    test("Create a group then join group with another user then leave group",
            () async {
          final user = getMockUser();
          MockFirebaseAuth _auth = MockFirebaseAuth();
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: "Password123!");
          await _auth.signInWithEmailAndPassword(
              email: user.email!, password: "Password123!");
          DatabaseMockService database =
          DatabaseMockService(uid: _auth.currentUser?.uid);

          var groupId = "";
          var code = "";

          var firstname = _auth.currentUser?.email;

          await database.updateUserData(firstname!, firstname, "19", "", false, 0);

          await database.createGroup("GroupExample");

          await database.getcurrentUser().then((value) async {
            groupId = await value["groupId"];
          });

          var group_doc =
          await database.firestore.collection("groups").doc(groupId).get();

          List<dynamic> group_length = group_doc["listOfUsers"];
          expect(group_length.length, 1);

          code = await group_doc["JoinCode"];

          _auth.signOut();

          await mockSignInAnon(user);

          final auth = MockFirebaseAuth(mockUser: user);
          await auth.signInAnonymously();

          var name = auth.currentUser?.uid;
          await database.changeUid(name!);

          await database.updateUserData(mockName(), mockName(), "19", "", true, 0);

          await database.addUserToGroup(code);
          group_doc =
          await database.firestore.collection("groups").doc(groupId).get();

          group_length = group_doc["listOfUsers"];

          expect(group_length.length, 2);

          await database.removeUserFromGroup(groupId);
          group_doc =
          await database.firestore.collection("groups").doc(groupId).get();

          group_length = group_doc["listOfUsers"];

          expect(group_length.length, 1);
        });
  });
}
