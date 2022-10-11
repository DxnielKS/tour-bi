

import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:bicycle_hire_app/screens/favourites/favourite_places/fav_places_provider.dart';
import 'package:bicycle_hire_app/screens/favourites/favourites_grid.dart';
import 'package:bicycle_hire_app/screens/favourites/route_names_provider.dart';
import 'package:bicycle_hire_app/screens/favourites/route_place_list.dart';
import 'package:bicycle_hire_app/screens/favourites/route_save.dart';
import 'package:bicycle_hire_app/screens/favourites/route_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; 

void main() async{
  Widget favouritesGridWidget(){
    return const MaterialApp(
      home: FavouritesGrid(),
    );
  }
  testWidgets("Given the favourites grid screen, When the favourite places is tapped on, Then the favourite places screen is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Places")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(FavouritePlacesProvider), findsOneWidget);
    // int noOfFavPlaces = tester.widgetList<ListView>(find.byKey(ValueKey("FavouritePlacesList"))).length;
    // expect(noOfFavPlaces, 1);
  });

  testWidgets("Given the favourites places screen, When a place is tapped on, Then the place tile is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Places")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(FavouritePlacesProvider), findsOneWidget);
    expect(find.byType(PlaceTile), findsWidgets);
  });


  testWidgets("Given the favourites places place tile screen, When the add to route button is tapped on, Then the place tile added to route", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Places")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("AddToRouteButton")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritePlacesProvider), findsOneWidget);
    // expect(find.byType(PlaceTile), findsNothing);
    // var f = find.byKey(ValueKey("FavouritePlacesList"));
    // int noOfFavPlaces = tester.widgetList<ListView>(find.byKey(ValueKey("FavouritePlacesList"))).length;
    // expect(noOfFavPlaces, 0);
  });

  testWidgets("Given the favourites places place tile screen, When the add to favourite route button is tapped on, Then the place tile added to saved route", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Places")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("AddToSavedRoute")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Route1"));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritePlacesProvider), findsOneWidget);
    // expect(find.byType(PlaceTile), findsNothing);
    // var f = find.byKey(ValueKey("FavouritePlacesList"));
    // int noOfFavPlaces = tester.widgetList<ListView>(find.byKey(ValueKey("FavouritePlacesList"))).length;
    // expect(noOfFavPlaces, 0);
  });

  testWidgets("Given the favourites places place tile screen, When the Delete from favourites button is tapped on, Then the place tile is popped", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Places")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("FavPlaceTileButton")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(FavouritePlacesProvider), findsOneWidget);
    // expect(find.byType(PlaceTile), findsNothing);
    // var f = find.byKey(ValueKey("FavouritePlacesList"));
    // int noOfFavPlaces = tester.widgetList<ListView>(find.byKey(ValueKey("FavouritePlacesList"))).length;
    // expect(noOfFavPlaces, 0);
  });

  testWidgets("Given the favourites grid screen, When the favourite routes is tapped on, Then the favourite routes screen is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsOneWidget);
  });

  testWidgets("Given the favourite routes screen, When the favourite routes is tapped on, Then the favourite route place list is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RouteTile).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("RouteTileButtonContainer")), findsOneWidget);
    await tester.tap(find.byKey(Key("RouteTileSeeButton")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsNothing);
    expect(find.byType(RoutePlaceList), findsOneWidget);
  });



  testWidgets("Given the favourite route place list screen, When a place is tapped on, Then the place tile is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RouteTile).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("RouteTileButtonContainer")), findsOneWidget);
    await tester.tap(find.byKey(Key("RouteTileSeeButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsNothing);
    expect(find.byType(RoutePlaceList), findsOneWidget);
    expect(find.byType(PlaceTile), findsWidgets);
  });

  testWidgets("Given the favourite route place tile, When Add to Saved Route is tapped on, Then a bottom sheet is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RouteTile).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("RouteTileButtonContainer")), findsOneWidget);
    await tester.tap(find.byKey(Key("RouteTileSeeButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("FavRoutePlaceTileAddButton")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("FavRoutePlaceTileButtonContainer")), findsOneWidget);
    expect(find.byType(RouteSave), findsWidgets);
    await tester.tap(find.byType(RouteSave).first);
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsNothing);
    expect(find.byType(RoutePlaceList), findsOneWidget);
    expect(find.byType(PlaceTile), findsWidgets);
  });

  testWidgets("Given the favourite route place tile, When Delete From Route is tapped on, Then the place tile is popped", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RouteTile).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("RouteTileButtonContainer")), findsOneWidget);
    await tester.tap(find.byKey(Key("RouteTileSeeButton")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("FavRoutePlaceTileDeleteButton")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsNothing);
    expect(find.byType(RoutePlaceList), findsOneWidget);
    // expect(find.byType(PlaceTile), findsNothing);
  });

  testWidgets("Given the favourite routes screen, When the favourite routes and then Delete Route is tapped on, Then the bottom sheet is popped", (WidgetTester tester) async{
    await tester.pumpWidget(favouritesGridWidget());
    await tester.pump();
    await tester.tap(find.byKey(Key("Favourite Routes")));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RouteTile).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("RouteTileButtonContainer")), findsOneWidget);
    await tester.tap(find.byKey(Key("RouteTileDeleteButton")));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsNothing);
    expect(find.byType(RouteNameProvider), findsOneWidget);
    expect(find.byType(RoutePlaceList), findsNothing);
  });
}