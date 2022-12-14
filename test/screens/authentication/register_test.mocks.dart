// Mocks generated by Mockito 5.1.0 from annotations
// in bicycle_hire_app/test/screens/authentication/register_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:bicycle_hire_app/models/user_account.dart' as _i5;
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart' as _i3;
import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDocumentSnapshot_0<T extends Object?> extends _i1.Fake
    implements _i2.DocumentSnapshot<T> {}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.Account?> get user => (super.noSuchMethod(
      Invocation.getter(#user),
      returnValue: Stream<_i5.Account?>.empty()) as _i4.Stream<_i5.Account?>);
  @override
  _i4.Future<dynamic> UpdateAccount(
          String? email, String? name, String? lastName, String? age) =>
      (super.noSuchMethod(
          Invocation.method(#UpdateAccount, [email, name, lastName, age]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> updateEmail(String? newEmail, String? Password) =>
      (super.noSuchMethod(Invocation.method(#updateEmail, [newEmail, Password]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> updatePassword(String? Password, String? newPassword) =>
      (super.noSuchMethod(
          Invocation.method(#updatePassword, [Password, newPassword]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> CreateAccount(String? email, String? password,
          String? name, String? lastName, String? age) =>
      (super.noSuchMethod(
          Invocation.method(
              #CreateAccount, [email, password, name, lastName, age]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> LogInWithEmail(String? email, String? password) =>
      (super.noSuchMethod(Invocation.method(#LogInWithEmail, [email, password]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> signInAnon(String? nickname) =>
      (super.noSuchMethod(Invocation.method(#signInAnon, [nickname]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> signOut(String? groupUID) =>
      (super.noSuchMethod(Invocation.method(#signOut, [groupUID]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<String?> getCurrentUserEmail() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUserEmail, []),
          returnValue: Future<String?>.value()) as _i4.Future<String?>);
  @override
  _i4.Future<bool?> getCurrentUserStatus() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUserStatus, []),
          returnValue: Future<bool?>.value()) as _i4.Future<bool?>);
  @override
  _i4.Future<String?> getCurrentUserfirstName() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUserfirstName, []),
          returnValue: Future<String?>.value()) as _i4.Future<String?>);
  @override
  _i4.Future<_i2.DocumentSnapshot<Object?>> getCurrentUser() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUser, []),
              returnValue: Future<_i2.DocumentSnapshot<Object?>>.value(
                  _FakeDocumentSnapshot_0<Object?>()))
          as _i4.Future<_i2.DocumentSnapshot<Object?>>);
  @override
  _i4.Future<String?> getCurrentUserLastName() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUserLastName, []),
          returnValue: Future<String?>.value()) as _i4.Future<String?>);
  @override
  _i4.Future<String?> getCurrentUserAge() =>
      (super.noSuchMethod(Invocation.method(#getCurrentUserAge, []),
          returnValue: Future<String?>.value()) as _i4.Future<String?>);

}
