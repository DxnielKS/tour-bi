import 'dart:ui';


import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:bicycle_hire_app/models/Place.dart' as PlaceModel;
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceTile extends StatefulWidget {
  final PlaceModel.Place place;
  final Widget button;
  final Color primaryColour;
  final Color secondaryColour;

  PlaceTile(
      {required this.place,
      required this.button,
      required this.primaryColour,
      required this.secondaryColour});

  @override
  State<PlaceTile> createState() => _PlaceTileState();
}

class _PlaceTileState extends State<PlaceTile> {
  String googleApikey = "AIzaSyCKOGbabmrKS5ty3mnW0hT88jQj8KG-aOE";
  late GoogleMapsPlaces apiPlace;
  final AuthService _auth = AuthService();

  Future<GoogleMapsPlaces> getPlist() async {
    final plist = GoogleMapsPlaces(
      apiKey: googleApikey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    return plist;
  }

  void _showInfoPanel() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.place.photoreferences.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              apiPlace.buildPhotoUrl(
                                  photoReference:
                                      widget.place.photoreferences[index],
                                  maxHeight: 500,
                                  maxWidth: 500),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Card(
                    color: widget.primaryColour,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Details",
                            style: TextStyle(
                              color: widget.secondaryColour,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: widget.primaryColour,
                              child: Icon(Icons.map_outlined),
                            ),
                            title: Text(
                              'Name: ${widget.place.name}',
                              style: TextStyle(
                                color: widget.secondaryColour,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: widget.primaryColour,
                              child: Icon(Icons.location_on),
                            ),
                            title: Text(
                              'Address: ${widget.place.address}',
                              style: TextStyle(
                                color: widget.secondaryColour,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: widget.primaryColour,
                              child: Icon(Icons.rate_review),
                            ),
                            title: Text(
                              'Rating: ${widget.place.rating}',
                              style: TextStyle(
                                color: widget.secondaryColour,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //button at the bottom of sheet
                widget.button,
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlist(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          apiPlace = snapshot.data;
          final TextStyle headline4 = Theme.of(context).textTheme.headline5!;
          return Column(
            children: [
              Container(
                  height: widget.place.photoreferences.isNotEmpty ? 320 : 100,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: _showInfoPanel,
                      child: Column(
                        children: [
                          Card(
                            elevation: 25,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white12,
                            child: Column(
                              children: [
                                Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  semanticContainer: true,
                                  color: Colors.transparent,
                                  child: widget.place.photoreferences.isNotEmpty
                                      ? Container(
                                          height: 240,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      apiPlace.buildPhotoUrl(
                                                          photoReference: widget
                                                                  .place
                                                                  .photoreferences[
                                                              0],
                                                          maxHeight: 200,
                                                          maxWidth:
                                                              250)) as ImageProvider)),
                                          child: Text(""))
                                      : Container(
                                          alignment: Alignment.bottomCenter,
                                          // Column(
                                          //   children: <Widget>[
                                          //     widget.place.photoreferences.isNotEmpty ?Image.network(
                                          //       apiPlace.buildPhotoUrl(
                                          //           photoReference: widget.place.photoreferences[0],
                                          //           maxHeight: 200,
                                          //           maxWidth: 250),
                                          //       fit: BoxFit.cover,
                                          //     ) : Image.asset("assets/images/NotFound.png"),
                                          //     Text(widget.place.name,style: TextStyle(color: Colors.white),),
                                          //   ],
                                          // ),
                                        ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                OurText(
                                  text: widget.place.name,
                                  fontSize: 23,
                                  color: Colors.white,
                                  underlined: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //   Card(
                    //     color: widget.secondaryColour,
                    //     margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                    //     child: ListTile(
                    //       leading:CircleAvatar(
                    //         backgroundColor: Colors.transparent,
                    //         radius: 50,
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(10),
                    //           child: widget.place.photoreferences.isNotEmpty ?Image.network(
                    //             apiPlace.buildPhotoUrl(
                    //                 photoReference: widget.place.photoreferences[0],
                    //                 maxHeight: 500,
                    //                 maxWidth: 500),
                    //             fit: BoxFit.fill,
                    //           ) : Image.asset("assets/images/NotFound.png"),
                    //         ),
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       title: Text(widget.place.name),
                    //       onTap: _showInfoPanel,
                    //     ),
                    //   ),
                    // );
                  )),
              SizedBox(
                height: 10,
              )
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
