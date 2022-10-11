
import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class JourneyActivityList extends StatefulWidget {
  const JourneyActivityList({Key? key}) : super(key: key);

  @override
  _JourneyActivityListState createState() => _JourneyActivityListState();
}

class _JourneyActivityListState extends State<JourneyActivityList> {
  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context);

    return FutureBuilder<int>(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
          }
          if (snapshot.hasError) {
            colourIndex = 0;
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: places?.length,
                    itemBuilder: (context, index) {
                      return PlaceTile(
                          place: places![index],
                          button: SizedBox(),
                          primaryColour: globals.themeColours[colourIndex],
                          secondaryColour: globals.textColours[colourIndex]);
                    }),
              ),
            ],
          );
        });
  }
}
