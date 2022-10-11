
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as route;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_data/mock_data.dart';
import 'package:firebase_auth_mocks/src/mock_user_credential.dart';

import 'firebaseMock.dart';
import 'screens/authentication/register_test.mocks.dart';


void mockSetup(){
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
  });
}

Future<void> mockSignInAnon(MockUser user) async {
final auth = MockFirebaseAuth(mockUser: user);
final result = await auth.signInAnonymously();
}

Future<void> mockSignIn(MockUser user) async {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  final result = await _auth.createUserWithEmailAndPassword(email: user.email!, password: "Password123!");
  final result2 = await _auth.signInWithEmailAndPassword(email: user.email!, password: "Password123!");
  print(_auth.currentUser?.uid);
}

MockUser getMockUser(){
  return MockUser(
    isAnonymous: true,
    uid: mockUUID(),
    email: mockName()+"@gmail.com",
    displayName: mockName(),
  );
}


Place getMockPlace(){
  var list = [];
  mockLocation().forEach((k, v) => list.add(v));
  return Place(
      placeId: mockUUID(),
      lng: list[1].toString(),
      lat: list[0].toString(),
      rating: "4.3",
      name: mockName(),
      address: mockName(),
      photoreferences: []);
}

List<Place> getMockListPlaces(int max){
  List<Place> places = [];
  for (var i = 0; i < max; i++) {
    places.add(getMockPlace());
  }
  return places;
}

route.Route getMockRoute(int max){
  return route.Route(name: mockUUID(), places: getMockListPlaces(max));
}

