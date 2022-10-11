import 'package:bicycle_hire_app/constants/customWidgets/route_name_form.dart';
import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/screens/activity_list/activities_provider.dart';
import 'package:bicycle_hire_app/screens/activity_list/activity_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';

void main() async{
  AuthService _auth = AuthService();
  Widget activityListWidget(){
    return MaterialApp(
        home: StreamProvider<List<Place>?>.value(
      value: DatabaseService(uid: _auth.getCurrent()?.uid).places,
      initialData: [],
      child: ActivityList(),
    ));
  }
  Widget activityListWidget1(){
    return MaterialApp(
        home: ActivitiesProvider());
  }
  testWidgets("Given the activity list screen, When Add to Favourite is tapped on, Then the route name form is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(activityListWidget());
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text("Add to Favourite"));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityList), findsOneWidget);
    expect(find.byType(RouteNameForm), findsOneWidget);
    final routeNameField = find.byKey(Key('RouteNameTextField'));
    await tester.enterText(routeNameField, "Route14");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Favourite"));
    await tester.pumpAndSettle();
    expect(find.byType(PlaceTile), findsWidgets);
    expect(find.byType(RouteNameForm), findsNothing);
  //   await tester.pumpAndSettle();
  });
  testWidgets("Given the activity list screen, When a place is tapped on, Then the place tile is pushed", (WidgetTester tester) async{
    await tester.pumpWidget(activityListWidget());
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    // await tester.tap(find.byIcon(Icons.location_city_rounded,));
    // await tester.pumpAndSettle();
    await tester.tap(find.byType(PlaceTile).first);
    await tester.pumpAndSettle();
    expect(find.byType(ActivityList), findsOneWidget);
    expect(find.byType(PlaceTile), findsWidgets);
    await tester.tap(find.text("Delete from route"));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityList), findsOneWidget);
  });
}