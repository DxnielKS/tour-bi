import 'dart:ui';


import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/screens/favourites/route_place_list.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:bicycle_hire_app/models/Route.dart' as routeModel;
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import '../../services/authHelpers/auth_service.dart';
import 'package:getwidget/getwidget.dart';

class RouteTile extends StatefulWidget {
  final routeModel.Route route;

  RouteTile({required this.route});

  @override
  State<RouteTile> createState() => _RouteTileState();
}

class _RouteTileState extends State<RouteTile> {
  String googleApikey = "AIzaSyCKOGbabmrKS5ty3mnW0hT88jQj8KG-aOE";

  Future<GoogleMapsPlaces> getPlist() async {
    final plist = GoogleMapsPlaces(
      apiKey: googleApikey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    return plist;
  }

  late GoogleMapsPlaces apiPlace;

  final AuthService _auth = AuthService();

  void _showInfoPanel() {
    showModalBottomSheet(
      backgroundColor: Colors.red.shade400,
        context: context,
        builder: (context) =>
        Container(
          key: Key("RouteTileButtonContainer"),
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          height: MediaQuery
              .of(context)
              .copyWith()
              .size
              .height * 0.25,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              child: Text(
                  "Number of places: ${widget.route.places.length}",
            style:GoogleFonts.notoKufiArabic(fontWeight: FontWeight.w900,color: Colors.black,letterSpacing: 0.9,fontSize: 18),),
            ),
            Container(
              child: ElevatedButton(
                key: Key("RouteTileDeleteButton"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade900),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red)
                        )
                    )
                ),
                onPressed: () async {
                  DatabaseService(uid: _auth
                      .getCurrent()
                      ?.uid).deleteRouteData(widget.route);
                  Navigator.pop(context);
                },
                child: Text("Delete Route"),
              ),
            ),
            Container(
              child: ElevatedButton(
                key: Key("RouteTileSeeButton"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red)
                        )
                    )
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          RoutePlaceList(route: widget.route)));
                },
                child: Text("See route"),
              ),
            )
          ]
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headline4 = Theme.of(context).textTheme.bodyLarge!;
    return FutureBuilder(
      future: getPlist(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          apiPlace = snapshot.data;
          return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 10,
                child: GFListTile(
                  avatar: Icon(Icons.favorite,color:Colors.red.shade900),
                  title: Text("",style: TextStyle(fontSize: 14),),
                  subTitle: OurText(text:widget.route.name[0].toUpperCase() + widget.route.name.substring(1).toLowerCase(),
                    underlined: false, color: Colors.white,fontSize:15,),

                  onTap: _showInfoPanel,
                )
              )
              );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
