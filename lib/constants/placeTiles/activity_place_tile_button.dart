import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class ActivityPlaceTileButton extends StatelessWidget {
  Place place;

  Color colour;

  Color secondaryColour;
  ActivityPlaceTileButton({ required this.place, required this.colour, required this.secondaryColour});
  final AuthService _auth = AuthService();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RoundedLoadingButton(
        color: colour,
        successColor: Colors.green,
        child: Text('Delete from route', style: TextStyle(color: secondaryColour)),
        controller: _btnController,
        onPressed: () async {
          var data = DatabaseService(uid: _auth.getCurrent()?.uid);
          data.getAllPlacesDocs().then((value) {
            data.deletePlaceData(place.placeId);
          });
          _btnController.success();
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        },
      ),
    );
  }
}