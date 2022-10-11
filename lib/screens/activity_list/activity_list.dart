
import 'package:bicycle_hire_app/constants/placeTiles/activity_place_tile_button.dart';
import 'package:bicycle_hire_app/constants/placeTiles/place_tile.dart';
import 'package:bicycle_hire_app/constants/customWidgets/route_name_form.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class ActivityList extends StatefulWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context);
    final AuthService _auth = AuthService();
    List<Place> favouriteList = [];

    void _showChooseRouteNamePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: RouteNameForm(favouriteList: favouriteList),
            );
          });
    }

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
                    key: Key("ActivityList"),
                    itemCount: places?.length,
                    itemBuilder: (context, index) {
                      return PlaceTile(
                          place: places![index],
                          button: ActivityPlaceTileButton(
                            place: places[index],
                            colour: globals.themeColours[colourIndex],
                            secondaryColour: globals.textColours[colourIndex],
                          ),
                          primaryColour: globals.themeColours[colourIndex],
                          secondaryColour: globals.textColours[colourIndex]);
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    favouriteList = places!;
                    _showChooseRouteNamePanel();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan.shade500,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Add to Favourite",
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
            ],
          );
        });
  }
}
