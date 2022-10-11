import 'package:bicycle_hire_app/screens/favourites/route_place_list.dart';
import 'package:bicycle_hire_app/screens/favourites/route_save.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class FavRoutePlaceTileButton extends StatelessWidget {
  Place place;
  RouteModel.Route route;

  Color colour;

  Color secondaryColour;
  FavRoutePlaceTileButton({ required this.place, required this.route , required this.colour,required this.secondaryColour});
  final AuthService _auth = AuthService();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _secondBtnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: RoundedLoadingButton(
            key: Key("FavRoutePlaceTileDeleteButton"),
            color: colour,
            width: 150,
            successColor: Colors.green,
            child: Text('Delete From Route', style: TextStyle(color: secondaryColour)),
            controller: _btnController,
            onPressed: () async {
              DatabaseService(uid: _auth.getCurrent()?.uid).deletePlaceFromRoute(place, route);
              _btnController.success();
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context);
                route.places.remove(place);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => RoutePlaceList(route: route)));
              });
              },
          ),
        ),
        Container(
          child: RoundedLoadingButton(
            key: Key("FavRoutePlaceTileAddButton"),
            color:colour,
            width: 150,
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
    );
  }
}