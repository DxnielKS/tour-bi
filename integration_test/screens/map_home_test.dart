import 'package:bicycle_hire_app/constants/customWidgets/OurToggle.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/screens/authentication/toggle.dart';
import 'package:bicycle_hire_app/screens/favourites/favourites_grid.dart';
import 'package:bicycle_hire_app/screens/map/MapHome.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';

void main() async {
  AuthService _auth = AuthService();
  //_auth.signOut("");

  Widget mapHomeWidget() {
    return MaterialApp(home: MapHome());
  }

  //
  testWidgets("Pump map home", (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
  });

  testWidgets("Given map home, tap on favourites", (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(
      Icons.favorite_outlined,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(FavouritesGrid), findsOneWidget);
    expect(find.byType(MapHome), findsOneWidget);
  });

  // testWidgets("Given map home, tap on activity list", (WidgetTester tester) async{
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   expect(find.byType(GoogleMap), findsOneWidget);
  //   await tester.tap(find.byIcon(Icons.location_city_rounded,));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(ActivityList), findsOneWidget);
  //   expect(find.byType(MapHome), findsOneWidget);
  //   expect(find.byType(GoogleMap), findsNothing);
  // });

  testWidgets("Given map home, tap on map icon", (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(
      Icons.map_rounded,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  // testWidgets("Given map home, tap on map icon", (WidgetTester tester) async{
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byTooltip('Open navigation menu'));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(MapHome), findsOneWidget);
  //   expect(find.byType(GoogleMap), findsOneWidget);
  // });

  testWidgets(
      "Given map home, tap on search icon and search a location within London and click on the first result that comes up",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), "KCL");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(
        find.text("King's College London, Strand, London, UK"), findsOneWidget);
    await tester.tap(find.text("King's College London, Strand, London, UK"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on search icon and search a location outside of London and click on the first result that comes up and see an alert to inform the user that this location is outside of london",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), "harrow");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.text("Harrow, UK"), findsOneWidget);
    await tester.tap(find.text("Harrow, UK"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.tap(find.text("Okay"));
    await tester.pumpAndSettle();
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on speed Dial and change the theme of the App and Map",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.color_lens));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListView).at(0));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on speed Dial and remove all the markers on the map",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.cached));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on speed Dial and track the users location and then stop tracking the users location",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.my_location));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.my_location));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on speed Dial and search for the closest bike point to the user",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.directions_bike));
    await tester.pumpAndSettle();
    final signInToggle = find.byKey(Key("Number of bikes field"));
    await tester.enterText(signInToggle, "1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    final signInToggle1 = find.byKey(Key("Number of spaces field"));
    await tester.enterText(signInToggle1, "1");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();
    await tester.pump(new Duration(seconds: 8));
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on the toggle in order to view the list of London attractions",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Toggle));
    await tester.pumpAndSettle();
    expect(find.text("London Attractions"), findsOneWidget);
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on a London attraction and tap a button to add it to the route of the user",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(ListView), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.tap(find.byType(ListView).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Add to route"));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on a London attraction and tap a button to favourite this attraction",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(ListView), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.tap(find.byType(ListView).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Add to favourite places"));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on a London attraction and tap a button to save this place to an already made route",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 4));
    expect(find.byType(ListView), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.tap(find.byType(ListView).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Add to favourite routes"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Route1"));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on the button to start the journey whilst on bikes",
      (WidgetTester tester) async {
        // var data = DatabaseService(uid: _auth.getCurrent()?.uid);
        // await data.createGroup("groupexample");
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.navigation_sharp));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    expect(find.text("Yes"), findsOneWidget);
    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    // await data.disbandGroup("groupexample");
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on the button to start the journey whilst not on bikes",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.navigation_sharp));
    await tester.pumpAndSettle();
    await tester.pump(new Duration(seconds: 5));
    expect(find.text("No"), findsOneWidget);
    await tester.tap(find.text("No"));
    await tester.pumpAndSettle();
    await tester.pump(new Duration(seconds: 5));
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.my_location));
    await tester.pumpAndSettle();
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on the button to start the journey then cancel the journey",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.navigation_sharp));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
    expect(find.text("Yes"), findsOneWidget);
    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconsButton));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
    expect(find.byType(MapHome), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
  });

  testWidgets(
      "Given map home, tap on the button to start the journey then tap on the Speed Dial and check for the places visited so far.",
      (WidgetTester tester) async {
    await tester.pumpWidget(mapHomeWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.navigation_sharp));
    await tester.pumpAndSettle();
    expect(find.text("Yes"), findsOneWidget);
    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    await tester.tap(find.byIcon(Icons.info));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
  });

  // testWidgets(
  //     "Given map home, tap on the button to start the journey then switch to the turn by turn navigation",
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.navigation_sharp));
  //   await tester.pumpAndSettle();
  //   expect(find.text("Yes"), findsOneWidget);
  //   await tester.tap(find.text("Yes"));
  //   await tester.pumpAndSettle();
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(SpeedDial));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pumpAndSettle();
  // });

  // testWidgets("Given map home, tap on search icon, search for place and tap on add to route", (WidgetTester tester) async{
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.search));
  //   await tester.pumpAndSettle();
  //   final searchBar = find.text('Search');
  //   await tester.tap(find.text('Search'));
  //   await tester.pumpAndSettle();
  //   await tester.enterText(searchBar, "London eye");
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text("London Eye, London, UK"));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(Marker));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsOneWidget);
  //   await tester.tap(find.text("Add to route"));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsNothing);
  //   expect(find.byType(MapHome), findsOneWidget);
  //   expect(find.byType(GoogleMap), findsOneWidget);
  // });
  // testWidgets("Given map home, tap on search icon, search for place and tap on add to favourite places", (WidgetTester tester) async{
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.search));
  //   await tester.pumpAndSettle();
  //   final searchBar = find.text('Search');
  //   await tester.enterText(searchBar, "London eye");
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text("London Eye, London, UK"));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(Marker));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsOneWidget);
  //   await tester.tap(find.text("Add to favourite places"));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsNothing);
  //   expect(find.byType(MapHome), findsOneWidget);
  //   expect(find.byType(GoogleMap), findsOneWidget);
  // });

  // testWidgets("Given map home, tap on search icon, search for place and tap on add to favourite routes", (WidgetTester tester) async{
  //   await tester.pumpWidget(mapHomeWidget());
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.search));
  //   await tester.pumpAndSettle();
  //   final searchBar = find.text('Search');
  //   await tester.enterText(searchBar, "London eye");
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text("London Eye, London, UK"));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(Marker));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsOneWidget);
  //   await tester.tap(find.text("Add to favourite routes"));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(RouteSave), findsWidgets);
  //   await tester.tap(find.byType(RouteSave).first);
  //   await tester.pumpAndSettle();
  //   expect(find.byType(PlaceTile), findsOneWidget);
  //   expect(find.byType(MapHome), findsOneWidget);
  //   expect(find.byType(GoogleMap), findsOneWidget);
  // });
}
