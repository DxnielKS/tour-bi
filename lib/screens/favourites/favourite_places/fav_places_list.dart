
import 'package:bicycle_hire_app/constants/placeTiles/fav_place_tile_button.dart';
import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';

class FavouritePlacesList extends StatefulWidget {
  const FavouritePlacesList({Key? key}) : super(key: key);

  @override
  _FavouritePlacesListState createState() => _FavouritePlacesListState();
}

class _FavouritePlacesListState extends State<FavouritePlacesList> {
  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context);
    final AuthService _auth = AuthService();

    return FutureBuilder<int>(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
          }if (snapshot.hasError){
            colourIndex = 0;
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    key: Key("FavouritePlacesList"),
                    itemCount: places?.length,
                    itemBuilder: (context, index) {
                      return PlaceTile(
                          place: places![index],
                          //TO DO: add a button to remove places
                          button: FavPlaceTileButton(place: places[index],colour:globals.themeColours[colourIndex],secondaryColour:globals.textColours[colourIndex]),
                          primaryColour: globals.themeColours[colourIndex],
                          secondaryColour: globals.textColours[colourIndex]);
                    }),
              ),
            ],
          );
        });
  }
}
