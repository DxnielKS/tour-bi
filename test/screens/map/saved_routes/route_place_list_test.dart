import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/screens/favourites/route_place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bicycle_hire_app/models/Route.dart' as route;

import '../../../database_mock_service.dart';
import '../../../mock_data.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(home: child);
  }

  mockSetup();

  group("Route Places List Testing", () {
    testWidgets("Route List shows places saved on that route",
        (WidgetTester tester) async {
      final user = getMockUser();
      route.Route route_example = getMockRoute(2);
      mockSignInAnon(user);

      await tester.pumpWidget(createWidgetForTesting(
          child: RoutePlaceList(
        route: route_example,
      )));

      var future_builder = find.byType(FutureBuilder<int>);
      expect(future_builder, findsOneWidget);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var place_tile = find.byType(PlaceTile);
      expect(place_tile, findsWidgets);

      await tester.press(place_tile.first);
      await tester.pumpAndSettle();
    });
    testWidgets("Route List shows places saved on that route",
        (WidgetTester tester) async {
      final user = getMockUser();
      route.Route route_example = getMockRoute(0);
      mockSignInAnon(user);

      await tester.pumpWidget(createWidgetForTesting(
          child: RoutePlaceList(
        route: route_example,
      )));

      var future_builder = find.byType(FutureBuilder<int>);
      expect(future_builder, findsOneWidget);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var place_tile = find.byType(PlaceTile);
      expect(place_tile, isNot(findsWidgets));
    });
    test("Check User can delete a place from their saved route", () async {
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      Place place_example = getMockPlace();

      route.Route route_example1 =
          route.Route(name: "route_example", places: [getMockPlace(), place_example]);

      route.Route route_example2 = getMockRoute(1);

      await database.updateRouteData(route_example1);
      await database.updateRouteData(route_example2);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.first.data().length, 2);
      });

      await database.savePlaceRoute(place_example, route_example2.name);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.last.data().length, 2);
      });
    });
  });
}
