import 'dart:io';

import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/map/MapHome.dart';
import 'package:bicycle_hire_app/services/authHelpers/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import './screens/favourites_test.dart' as favourites;
import './screens/activity_list_test.dart' as activityList;
import './screens/map_home_test.dart' as mapHome;
import './screens/authentication_test.dart' as authentication;
import './screens/profile_test.dart' as profile;
import './screens/groups_test.dart' as groups;
import './screens/sidebar_test.dart' as sidebar;

void main() async {
  //setupFirebaseAuthMocks();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AuthService _auth = AuthService();
  setUpAll(() async {
    HttpOverrides.global = null;
    await _auth.CreateAccount(
        "test0@example.org", "Password123!", "Test0", "Example", "22");
    Account? account =
        await _auth.LogInWithEmail("test0@example.org", "Password123!");
    // await DatabaseService(uid: _auth.getCurrent()?.uid).deleteUser();
    // await _auth.CreateAccount("test0@example.org", "Password123!", "Test0", "Example", "22");
    // await _auth.LogInWithEmail("test0@example.org", "Password123!");
    var data = DatabaseService(uid: _auth.getCurrent()?.uid);
    Place place = Place(
        placeId: "ChIJ3VW0o7UEdkgRjZLQfvs-ZLA",
        lng: "-0.115997",
        lat: "51.51148639999999",
        rating: "4.3",
        name: "King's College London",
        address: "Strand, London WC2R 2LS, UK",
        photoreferences: [
          "Aap_uEDUoQZcim8GG73wplNJOV9n81DqFbEvcqAl5g6mXO6_wEvqSXmqCOncuj3IlC46FNzFZcBiWPt5r79Q5aYuG2kVtKlFxpdOV8g680NA1b1L7UrVLmZ_DhpVGetjoRuYf71RhmfIE2dNeblIzqn9DB48eVYWZdTEHIoOlp7hyJAcgBHw",
          "Aap_uEDTMvPYj5xSl_nZdrK2DC0_3tXk9l4_ZF51iZ-kruXBayHM38Hb2m3NyJGx5lDMv6bq-Ny0ooz6FxJMn6iJy6KuIUPP9rVuRwi2MB_eGKbyL3e3iviE4Me3BjbMPmiJTSF0Wzb4ywjEZTfWZOFkUak4wJmWrcApzGXho7RN7_IOkk8l",
          "Aap_uECnrXYBsjf6ey4IbNKrYBjcqon486j9q-hRa-_Oj2mnDna1U0ixPdl4_Ao-iPIu6q8tdZKudpsv7iW-0RsjhVW_dzbi6WpPIPwEpg2WGybsPBvl80f1TuY9uxUdbiUKGcd8KSZgSh7DsuN6ITCLvaI6ExI7tJSG-JSjszSoO74XSUhF"
        ]);
    await data.updateFavPlaceData("London SW1A 1AA, UK", "51.501364",
        "-0.14189", "Buckingham Palace", "ChIJtV5bzSAFdkgRpwLZFPWrJgo", "4.5", [
      "Aap_uEBNHvvfoANRlU3OlPReEGLsGpUgckuJ-dz_GA2vAwZIJRfBBrXSzbPWAInvbHP6dCIQMUrqeayadthO5MGHXeBqLDm1K3F8SR2_xVoVV3jc4CYMR9Fs7iU-d_JXfTU3FyhIPQV5s2VEIRO74963LQVExvaMAbjOVoTEAkO7moHahAr2",
      "Aap_uEDK0FCH-ZIpJ8WblgdJiybPYjPfHueOw7qrBUKo0IGqFTuNQWN8_cLK0-rZws3I5ijf1abA1EqHYdyMgcA-FRADmh8ASuoX4qNCC2W0ijTbaBDrhQYlgcNmEafElpMfXbwM5Q_CxB-9iPVFM2kreV__Aw6UE9YF_Te6lkYm7RUZEkrA",
      "Aap_uEBJS056LQ2MkFCgYTcFJ0BSJBklNM602ozY-zPP0qUnl4mWD0vU4AD1_StnCrCG6Mk1F1rskokQx2M6EYlKV2ri1x64-SxFFh-qFQp0Fu0ByCji4dVpTAf8qQ9uzcweo2UU2TczfFOoCTPx9nSsszSq1vrXvjEsr8oghjELnsvYAtwB"
    ]);
    await data.updatePlaceData(
        "Strand, London WC2R 2LS, UK",
        "51.51148639999999",
        "-0.115997",
        "King's College London",
        "ChIJ3VW0o7UEdkgRjZLQfvs-ZLA",
        "4.3", [
      "Aap_uEDUoQZcim8GG73wplNJOV9n81DqFbEvcqAl5g6mXO6_wEvqSXmqCOncuj3IlC46FNzFZcBiWPt5r79Q5aYuG2kVtKlFxpdOV8g680NA1b1L7UrVLmZ_DhpVGetjoRuYf71RhmfIE2dNeblIzqn9DB48eVYWZdTEHIoOlp7hyJAcgBHw",
      "Aap_uEDTMvPYj5xSl_nZdrK2DC0_3tXk9l4_ZF51iZ-kruXBayHM38Hb2m3NyJGx5lDMv6bq-Ny0ooz6FxJMn6iJy6KuIUPP9rVuRwi2MB_eGKbyL3e3iviE4Me3BjbMPmiJTSF0Wzb4ywjEZTfWZOFkUak4wJmWrcApzGXho7RN7_IOkk8l",
      "Aap_uECnrXYBsjf6ey4IbNKrYBjcqon486j9q-hRa-_Oj2mnDna1U0ixPdl4_Ao-iPIu6q8tdZKudpsv7iW-0RsjhVW_dzbi6WpPIPwEpg2WGybsPBvl80f1TuY9uxUdbiUKGcd8KSZgSh7DsuN6ITCLvaI6ExI7tJSG-JSjszSoO74XSUhF"
    ]);
    //await data.createGroup("Example1");
    await data.updatePlaceData(
        "Edmund Halley Way, SE10 0FR",
        "51.499573",
        "0.008367",
        "Emirates Greenwich Peninsula",
        "ChIJA8it1huo2EcRdGaswImSuRc",
        "4.6", [
      "Aap_uECrZRYaicowIi8ciZU5m6ldRe3wwi_XWll8SjNgYjHOIoswysN63L_3f5RcFk-WCiTUl2RCq76M5duYupLwZaD0Vx-rIcptBctDmEp6Oy4ifAttVZKKZHzuiu1AKbaX541CnCldqiaJrRMbNPJq_rfYtPiJMa1NV8K9KMZWrnvS2z-U",
      "Aap_uED4L2S0UrWtem63EPOazbTTFf8PXuaUFIvu7Ab23f5SEVDHASTLYAwZaNAViyij9L3zBZ6D8lhcceNRvprjz8sZsYiFY30TDW9_07YylYUip0SLWaTW-QqjxJJtMvxpXAonsU3WsjpYKj3Fs0ZEp9AfedM2pLJtllJiSOasskV-yash",
    ]);
    RouteModel.Route route1 = RouteModel.Route(name: "Route1", places: [place]);
    await data.updateRouteData(route1);
  });

  tearDownAll(() async {
    //print("AAAAAAAAAAAAAAAAAAAAAAAA");
    await _auth.LogInWithEmail("example1@example.com", "Taz123!");
    User user1 = FirebaseAuth.instance.currentUser!;
    user1.delete();
    await _auth.LogInWithEmail("test0@example.org", "Password123!");
    //await DatabaseService(uid: _auth.getCurrent()?.uid).deleteUser();
    User user2 = FirebaseAuth.instance.currentUser!;
    user2.delete();
  });

  group("Map Home tests", () {
    mapHome.main();
  });

  group("Favourites tests", () {
    favourites.main();
  });

  group("Activity List tests", () {
    activityList.main();
  });


  group("Sidebar tests", () {
    sidebar.main();
  });

  group("Groups tests", () {
    groups.main();
  });

  group("Profile tests", () {
    profile.main();
  });

  group("Authentication tests", () {
    authentication.main();
  });

  // testWidgets("Given on boarding page, When you navigate through skip button, Then map home is pushed", (WidgetTester tester) async{
  // await tester.pumpWidget(onBoardingPageWidget());
  // await tester.pumpAndSettle();
  // await tester.tap(find.text("Skip"));
  // await tester.pumpAndSettle();
  // await tester.tap(find.text("Done"));
  // await tester.pumpAndSettle();
  // expect(find.byType(OnBoardingPage), findsNothing);
  // expect(find.byType(MapHome), findsOneWidget);
  //});
  //testWidgets("Sign in", (WidgetTester tester) async{
  //   await tester.pumpWidget(authenticateWidget());
  //   await tester.pumpAndSettle();
  //   final logInbutton = find.byKey(Key('Login Button'));
  //   var passwordForm = find.byKey(Key("Password Field"));
  //   var usernameForm = find.byKey(Key("Username field"));
  //   await tester.enterText(usernameForm, "test3@example.org");
  //   await tester.pumpAndSettle();
  //   await tester.enterText(passwordForm, "Password123!");
  //   await tester.pumpAndSettle();
  //   await tester.ensureVisible(logInbutton);
  //   await tester.pumpAndSettle();
  //   await tester.tap(logInbutton);
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byIcon(Icons.favorite_outlined,));
  //   await tester.pumpAndSettle();
  // });

  // group("Side bar tests", (){
  //   testWidgets("Given map home, tap on side bar", (WidgetTester tester) async{
  //     await tester.pumpWidget(mapHomeWidget());
  //     await tester.pumpAndSettle();
  //     scaffoldKey.currentState?.openDrawer();
  //     await tester.pumpAndSettle();
  //     // expect(find.byType(DrawerProvider), findsOneWidget);
  //     // expect(find.byType(MapHome), findsOneWidget);
  //   });

  // });
}
