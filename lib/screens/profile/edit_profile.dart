import 'package:avatars/avatars.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_container.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/screens/authentication/validation.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

import 'package:flutter/material.dart';

class editProfile extends StatefulWidget {
  final String email;
  final String firstName;
  final String surname;
  final String age;

  editProfile(
      {required this.email,
      required this.firstName,
      required this.surname,
      required this.age});

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String new_Email = '';
  String new_firstName = '';
  String new_surname = '';
  String new_age = '';
  String new_password = '';
  String old_password = '';
  bool loading = false;
  String error = '';
  int colourIndex = 0;
  AuthService _auth = AuthService();
  final Validator _validator = Validator();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
            return loading
                ? Loading()
                : Scaffold(
                    backgroundColor: globals.themeColours[colourIndex],
                    appBar: AppBar(
                      title: OurText(text:'Edit Profile',
                      fontSize: 25,color: Colors.white,underlined: false,),
                      centerTitle: true,
                      elevation: 0.0,
                      backgroundColor: globals.themeColours[colourIndex],
                    ),
                    body: Container(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: OurContainer(
                              primaryColour: Colors.white54,
                              secondaryColour: globals.themeColours[colourIndex],
                              child: ListView(
                                children: <Widget>[
                                  Center(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 30, 10, 10),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Avatar(
                                              name: widget.firstName
                                                      .toUpperCase() +
                                                  ' ' +
                                                  widget.surname.toUpperCase(),
                                              placeholderColors: [
                                                Color(0xFFFF0000),
                                                Color.fromARGB(255, 89, 0, 255),
                                                //...
                                              ]),
                                        ),
                                        Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(height: 40,),
                                                TextFormField(
                                                  key: Key("Edit profile first name"),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      new_firstName = val;
                                                    });
                                                  },
                                                  decoration: InputDecoration(

                                                      contentPadding:
                                                          EdgeInsets.symmetric(vertical: 15),
                                                      labelText: "First Name",
                                                      labelStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      hintText:
                                                          widget.firstName,
                                                      hintStyle: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey)),
                                                  validator: (val) =>
                                                      !(_validator.validateName(
                                                              val!))
                                                          ? 'enter a name'
                                                          : null,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  key: Key("Edit profile surname"),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      new_surname = val;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.symmetric(vertical: 15),
                                                      labelText: 'Surname',
                                                      labelStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      hintText: widget.surname,
                                                      hintStyle: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey)),
                                                  validator: (val) =>
                                                      !(_validator.validateName(
                                                              val!))
                                                          ? 'enter a name'
                                                          : null,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  key: Key("Edit profile age"),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      new_age = val;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.symmetric(vertical: 15),
                                                      labelText: 'Age',
                                                      labelStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      hintText: widget.age,
                                                      hintStyle: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey)),
                                                  validator: (val) => !(_validator
                                                          .validateAge(val!))
                                                      ? 'You need to be 18 or older to continue..'
                                                      : null,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          error,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          key: Key("Edit profile save button"),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                dynamic signUpAttempt =
                                                    await _auth.UpdateAccount(
                                                        new_Email,
                                                        new_firstName,
                                                        new_surname,
                                                        new_age);
                                                if (signUpAttempt == null) {
                                                  setState(() {
                                                    loading = false;
                                                    error =
                                                        'Enter Valid Details';
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              }
                                            },
                                            child: Text('Save'))
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ))),
                  );
          }
          return Container();
        });
  }
}
