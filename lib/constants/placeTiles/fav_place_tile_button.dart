import 'package:bicycle_hire_app/screens/favourites/route_save.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class FavPlaceTileButton extends StatelessWidget {
  Place place;

  Color secondaryColour;

  Color colour;
  FavPlaceTileButton({ required this.place, required this.colour, required this.secondaryColour});
  final AuthService _auth = AuthService();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _secondBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _thirdBtnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: RoundedLoadingButton(
                width: MediaQuery.of(context).size.width / 3,
                color:colour,
                successColor: Colors.green,
                key: Key("AddToRouteButton"),
                child: Text('Add to route', style: TextStyle(
                        color: secondaryColour)),
                controller: _btnController,
                onPressed: () async {
                  var data = await DatabaseService(
                      uid: _auth.getCurrent()?.uid);
                  data
                      .checkIfPlaceExists(place.placeId)
                      .then((value) async {
                    if (!value) {
                      List<String> photoref = [];
                      for (String photo in place.photoreferences) {
                        photoref.add(photo);
                      }
                      data.updatePlaceData(
                          place.address,
                          place.lat,
                          place.lng,
                          place.name,
                          place.placeId,
                          place.rating.toString(),
                          photoref);
                      _btnController.success();
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ),
            Container(
              child: RoundedLoadingButton(
                width: MediaQuery.of(context).size.width / 3,
                color:colour,
                key: Key("AddToSavedRoute"),
                successColor: Colors.green,
                child: Text('Add to Saved Route', style: TextStyle(color: secondaryColour)),
                controller: _secondBtnController,
                onPressed: () async {
                  var data = await DatabaseService(
                      uid: _auth
                          .getCurrent()
                          ?.uid);
                  data.getAllRoutesDocs().then((value) {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                        (Container(
                            key: Key("FavRoutePlaceTileButtonContainer"),
                            child: Column(children: [
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: value.docs.length,
                                      itemBuilder: (context, index) {
                                        return RouteSave(
                                          route: value.docs[index].id,
                                          place: place,);

                                      }))
                            ]))));
                    _secondBtnController.reset();
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 100,
        ),
        Container(
          child: RoundedLoadingButton(
            key: Key("FavPlaceTileButton"),
            color: colour,
            successColor: Colors.green,
            child: Text('Delete from favourites', style: TextStyle(color: secondaryColour)),
            controller: _thirdBtnController,
            onPressed: () async {
              var data = DatabaseService(uid: _auth.getCurrent()?.uid);
              data.getAllFavPlacesDocs().then((value) {
                data.deleteFavPlaceData(place.placeId);
              });
              _thirdBtnController.success();
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            },
          )
        ),
      ],
    );
  }
}

