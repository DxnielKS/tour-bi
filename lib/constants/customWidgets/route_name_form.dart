import 'package:bicycle_hire_app/constants/customWidgets/input_decoration.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';


class RouteNameForm extends StatefulWidget {
  List<Place> favouriteList = [];
  RouteNameForm({ required this.favouriteList });

  @override
  _RouteNameFormState createState() => _RouteNameFormState();
}

class _RouteNameFormState extends State<RouteNameForm> {
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  // form values
  String? _currentName = null;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Name Your Route',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            key: Key("RouteNameTextField"),
            decoration: textInputDecoration.copyWith(hintText: 'Route Name',
            errorText: _validate ? 'This route name has already been used': null,),
            onChanged: (val) => setState(() => _currentName = val),
            validator: (val) => val!.isEmpty ? 'Please enter a Route Name' : null, ),
          ElevatedButton(
            child: Text(
              'Favourite',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if(_formKey.currentState!.validate()){
                 RouteModel.Route route = RouteModel.Route(name: _currentName.toString() , places:  widget.favouriteList);
                var data = await DatabaseService(
                    uid: _auth.getCurrent()?.uid);
                if(!(await data.checkIfRouteExists(route))){
                  data.updateRouteData(route);
                  Navigator.pop(context);
                }
                else{
                  setState(() {
                    _validate = true;
                  });
                }
              }
            }
          )
        ]
      )
    );
  }
}