import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/screens/activity_list/activity_list.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database_mock_service.dart';
import '../../../firebaseMock.dart';
import '../../../mock_data.dart';

void main() {
  Widget createWidgetForTesting({required Widget child, required var data}) {
    return MaterialApp(
        home: Provider<List<Place>?>.value(
      value: data!,
      child: child,
    ));
  }

  mockSetup();

  group("Activity List Testing", () {
    testWidgets("Activity List shows only places added",
        (WidgetTester tester) async {

      final user = getMockUser();
      List<Place> places = getMockListPlaces(1);
      mockSignInAnon(user);

      await tester.pumpWidget(
          createWidgetForTesting(child: ActivityList(), data: places));

      var future_builder = find.byType(FutureBuilder<int>);
      expect(future_builder, findsOneWidget);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var place_tile = find.byType(PlaceTile);
      expect(place_tile, findsOneWidget);

      await tester.press(place_tile);
      await tester.pumpAndSettle();
    });
    testWidgets("Activity List \" Add to Favourites \" button can be tapped",
        (WidgetTester tester) async {
      final user = getMockUser();
      List<Place> places = [];
      final auth = MockFirebaseAuth(mockUser: user);
      final result = await auth.signInAnonymously();

      await tester.pumpWidget(
          createWidgetForTesting(child: ActivityList(), data: places));

      var favourite = find.text("Add to Favourite");
      expect(favourite, findsOneWidget);

      await tester.press(favourite);
      await tester.pumpAndSettle();
    });
    testWidgets("Activity List shows no places if user hasn't selected any",
        (WidgetTester tester) async {
      final user = getMockUser();
      mockSignInAnon(user);

      List<Place> places = [];

      await tester.pumpWidget(
          createWidgetForTesting(child: ActivityList(), data: places));

      var future_builder = find.byType(FutureBuilder<int>);

      expect(future_builder, findsOneWidget);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var place_tile = find.byType(PlaceTile);
      expect(place_tile, findsNothing);
    });

    testWidgets(
        "Activity List shows 2 places if user has selected more than 1 place.",
        (WidgetTester tester) async {
      final user = getMockUser();
      List<Place> places = getMockListPlaces(2);
      mockSignInAnon(user);

      await tester.pumpWidget(
          createWidgetForTesting(child: ActivityList(), data: places));

      var future_builder = find.byType(FutureBuilder<int>);

      expect(future_builder, findsOneWidget);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var place_tile = find.byType(PlaceTile);
      // True since there is more than 1 Place Tile.
      expect(place_tile, isNot(findsOneWidget));
    });
    test("Check that user can add a place to their Activity List", () async {
      final firestore = FakeFirebaseFirestore();
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      await database.updatePlaceData(
          "London EC3N 4AB, UK",
          "51.50811239999999",
          "-0.0759493",
          "Tower of London",
          "ChIJ3TgfM0kDdkgRZ2TV4d1Jv6g",
          "4.6", []);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.first["Name"], "Tower of London");
        expect(value.docs.length, 1);
      });
    });
    test("Check that user can remove a place to their Activity List", () async {
      final firestore = FakeFirebaseFirestore();
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      await database.updatePlaceData(
          "London EC3N 4AB, UK",
          "51.50811239999999",
          "-0.0759493",
          "Tower of London",
          "ChIJ3TgfM0kDdkgRZ2TV4d1Jv6g",
          "4.6", []);

      await database.updatePlaceData("London EC3N 4A", "51.5081123999",
          "-0.0759", "example2", "ChIJ3VW007UEd", "4.6", []);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 2);
      });

      await database.deletePlaceData("ChIJ3VW007UEd");

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 1);
      });
    });
    test("Check that user cannot add the same place twice", () async {
      final firestore = FakeFirebaseFirestore();
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      await database.updatePlaceData(
          "London EC3N 4AB, UK",
          "51.50811239999999",
          "-0.0759493",
          "Tower of London",
          "ChIJ3TgfM0kDdkgRZ2TV4d1Jv6g",
          "4.6", []);

      await database.updatePlaceData(
          "London EC3N 4AB, UK",
          "51.50811239999999",
          "-0.0759493",
          "Tower of London",
          "ChIJ3TgfM0kDdkgRZ2TV4d1Jv6g",
          "4.6", []);

      await database.getAllPlacesDocs().then((value) {
        expect(value.docs.length, 1);
      });
    });
  });
}
