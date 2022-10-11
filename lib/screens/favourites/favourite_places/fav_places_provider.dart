import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/screens/favourites/favourite_places/fav_places_list.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';


class FavouritePlacesProvider extends StatefulWidget {

  @override
  _FavouritePlacesProviderState createState() => _FavouritePlacesProviderState();
}

class _FavouritePlacesProviderState extends State<FavouritePlacesProvider> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });
    return StreamProvider<List<Place>?>.value(
      value: DatabaseService(uid: _auth.getCurrent()?.uid).favouritePlaces,
      initialData: [],
      child:Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title:  OurText(text: 'Favourite Places',color: Colors.black, underlined: false,),
        ),
        body: Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.4,
                0.9,
              ],
              colors: [
                Colors.red,
                Colors.blueAccent,
              ],
            )
        ),child: SafeArea(child: FavouritePlacesList()))
      )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = true;
    });
  }
}