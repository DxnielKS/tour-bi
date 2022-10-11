import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:bicycle_hire_app/screens/favourites/favourites_grid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  group("Favourites Grid Tests", () {
    testWidgets("Test Activity List Widgets", (WidgetTester tester) async {
      await tester
          .pumpWidget(createWidgetForTesting(child: new FavouritesGrid()));
      var button = find.byType(OpenContainer<bool>);
      expect(button, findsWidgets);

      var list_view = find.byType(ListView);
      expect(list_view, findsOneWidget);

      var app_bar = find.text("Favourites");
      expect(app_bar, findsOneWidget);

      var places_text = find.text("Favourite Places");
      expect(places_text, findsOneWidget);

      var route_text = find.text("Favourite Routes");
      expect(route_text, findsOneWidget);

      var fake_text = find.text("Activity List");
      expect(fake_text, findsNothing);



    });
  });
}
