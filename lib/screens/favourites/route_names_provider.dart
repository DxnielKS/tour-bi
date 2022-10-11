import 'package:bicycle_hire_app/screens/favourites/route_name_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/models/Route.dart' as route;
import '../../services/authHelpers/auth_service.dart';
import '../../services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class RouteNameProvider extends StatefulWidget {

  @override
  _RouteNameProviderState createState() => _RouteNameProviderState();
}

class _RouteNameProviderState extends State<RouteNameProvider> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });

    return StreamProvider<List<route.Route>?>.value(
        value: DatabaseService(uid: _auth.getCurrent()?.uid).routes,
        initialData: [],
        child: RouteNameList()

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = true;
    });
  }
}