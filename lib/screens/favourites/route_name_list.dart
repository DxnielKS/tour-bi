
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/screens/favourites/route_tile.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;


class RouteNameList extends StatefulWidget {
  @override
  _RouteNameListState createState() => _RouteNameListState();
}

class _RouteNameListState extends State<RouteNameList> {
  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<List<RouteModel.Route>?>(context);


    final AuthService _auth = AuthService();

    return Scaffold(
      extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: OurText(text: 'Routes',color: Colors.white, underlined: false,fontSize: 25,),
        ),
        body: Container(
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
              )
          ),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount:routes!.length ,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ), itemBuilder: (context, index){
                  return RouteTile(route: routes[index]);
                })


                // ListView.builder(
                //     itemCount: routes!.length,
                //     itemBuilder: (context, index) {
                //       return RouteTile(route: routes[index],);
                //     }),
              ),
            ],
          ),
        ));
  }

}