import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/placeTiles/fav_route_place_tile_button.dart';
import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

import '../../services/authHelpers/auth_service.dart';

class RoutePlaceList extends StatefulWidget {
  RouteModel.Route route;

  RoutePlaceList({required this.route});

  @override
  _RoutePlaceListState createState() => _RoutePlaceListState();
}

class _RoutePlaceListState extends State<RoutePlaceList> {
  int colourIndex = 0;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });
    final TextStyle headline4 = Theme.of(context).textTheme.headline4!;
    return FutureBuilder<int>(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
          }
          if (snapshot.hasError) {
            colourIndex = 0;
          }
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.red,
              title: OurText(
                text: widget.route.name[0].toUpperCase() +
                    widget.route.name.substring(1).toLowerCase(),
                color: Colors.white,
                underlined: false,
                fontSize: 30,
              ),
            ),
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.4,
                    0.8,
                  ],
                  colors: [
                    Colors.red.shade500,
                    Colors.red.shade900,
                  ],
                )),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: widget.route.places.length,
                            itemBuilder: (context, index) {
                              return SafeArea(
                                child: PlaceTile(
                                    place: widget.route.places[index],
                                    button: FavRoutePlaceTileButton(
                                      place: widget.route.places[index],
                                      route: widget.route,
                                      colour: globals.themeColours[colourIndex],
                                      secondaryColour:
                                          globals.textColours[colourIndex],
                                    ),
                                    primaryColour:
                                        globals.themeColours[colourIndex],
                                    secondaryColour:
                                        globals.textColours[colourIndex]),
                              );
                            })
                        //   return FavePlaceTile(
                        //       place: widget.route.places[index], route: widget.route);
                        // }),
                        ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
