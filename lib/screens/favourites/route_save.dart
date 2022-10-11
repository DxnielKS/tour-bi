import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';

class RouteSave extends StatefulWidget {
  final String route;
  final Place place;
  RouteSave({required this.route, required this.place});

  @override
  State<RouteSave> createState() => _RouteSaveState();

}
class _RouteSaveState extends State<RouteSave> {
  String googleApikey = "AIzaSyCKOGbabmrKS5ty3mnW0hT88jQj8KG-aOE";

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            title: Text(widget.route),
            onTap: () async {
              var data = await DatabaseService(
                  uid: _auth.getCurrent()?.uid);
              data.savePlaceRoute(widget.place, widget.route);
              Navigator.pop(context);
            },
          ),
        ));
  }
}