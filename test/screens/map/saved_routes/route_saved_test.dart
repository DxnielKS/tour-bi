
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/screens/favourites/route_name_list.dart';
import 'package:bicycle_hire_app/screens/favourites/route_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/models/Route.dart' as route;

import '../../../database_mock_service.dart';
import '../../../mock_data.dart';

void main() {
  Widget createWidgetForTesting({required Widget child, required var data}) {
    return MaterialApp(
        home: Provider<List<route.Route>?>.value(
      value: data!,
      child: child,
    ));
  }
  
  mockSetup();

  group("Saved Routes Testing", () {
    testWidgets("1 saved routes show on screen", (WidgetTester tester) async {
      final user = getMockUser();

      route.Route route_example = getMockRoute(2);
      List<route.Route> routes = [route_example];


      mockSignInAnon(user);

      await tester.pumpWidget(
          createWidgetForTesting(child: RouteNameList(), data: routes));

      var custom_text = find.byType(OurText);
      expect(custom_text, findsOneWidget);

      var grid_view = find.byType(GridView);
      expect(grid_view, findsOneWidget);

      var route_tile = find.byType(RouteTile);
      expect(route_tile, findsWidgets);

      await tester.tap(route_tile);
      await tester.pumpAndSettle();
    });
    testWidgets("2 routes shown on screen and both can be tapped",
        (WidgetTester tester) async {
      final user = getMockUser();

      route.Route route_example1 = getMockRoute(2);
      route.Route route_example2 = getMockRoute(2);
      List<route.Route> routes = [route_example1, route_example2];

      mockSignInAnon(user);

      await tester.pumpWidget(
          createWidgetForTesting(child: RouteNameList(), data: routes));

      var custom_text = find.byType(OurText);
      expect(custom_text, findsOneWidget);

      var grid_view = find.byType(GridView);
      expect(grid_view, findsOneWidget);

      var route_tile = find.byType(RouteTile);
      expect(route_tile, findsWidgets);

      await tester.tap(route_tile.first);
      await tester.pumpAndSettle();

      //exit bottom sheet
      await tester.press(find.byType(AppBar));

      await tester.tap(route_tile.last);
      await tester.pumpAndSettle();
    });
    testWidgets("0 routes shown on screen", (WidgetTester tester) async {
      final user = getMockUser();
      List<route.Route> routes = [];

      mockSignInAnon(user);

      await tester.pumpWidget(
          createWidgetForTesting(child: RouteNameList(), data: routes));

      var custom_text = find.byType(OurText);
      expect(custom_text, findsOneWidget);

      var grid_view = find.byType(GridView);
      expect(grid_view, findsOneWidget);

      var route_tile = find.byType(RouteTile);
      expect(route_tile, isNot(findsWidgets));
    });
    test("Check that user can add a route to their saved routes list",
        () async {
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      route.Route route_example = getMockRoute(2);

      await database.updateRouteData(route_example);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 1);
      });
    });
    test("Check that user can remove a route from their saved routes list",
        () async {
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      route.Route route_example1 = getMockRoute(2);

      route.Route route_example2 = getMockRoute(2);

      await database.updateRouteData(route_example1);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 1);
      });

      await database.updateRouteData(route_example2);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 2);
      });

      await database.deleteRouteData(route_example2);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 1);
      });
    });
    test(
        "Check that user cannot add a route with the same name as another route",
        () async {
      final user = getMockUser();
      DatabaseMockService database = DatabaseMockService(uid: user.uid);

      mockSignInAnon(user);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 0);
      });

      route.Route route_example1 = getMockRoute(2);

      route.Route route_example2 =
          route.Route(name: route_example1.name, places: getMockListPlaces(2));

      await database.updateRouteData(route_example1);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 1);
      });

      await database.updateRouteData(route_example2);

      await database.getAllRoutesDocs().then((value) {
        expect(value.docs.length, 1);
      });
    });
  });
}
