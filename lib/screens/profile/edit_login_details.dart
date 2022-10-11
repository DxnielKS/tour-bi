import 'package:avatars/avatars.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_container.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/screens/authentication/validation.dart';
import 'package:bicycle_hire_app/screens/introPage/intro_screen.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class editLoginDetails extends StatefulWidget {
  final String oldPassword;

  const editLoginDetails({required this.oldPassword});

  @override
  _editLoginDetailsState createState() => _editLoginDetailsState();
}

class _editLoginDetailsState extends State<editLoginDetails> {
  @override
  AuthService _auth = AuthService();
  String newEmail = '';
  String newPassword = '';
  String confirmPassword = '';
  String emailSuccess = '';
  String passwordSuccess = '';
  bool loading = false;
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  int colourIndex = 0;
  Validator _validator = Validator();

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
                      title: Text('Edit Profile'),
                      centerTitle: true,
                      elevation: 0.0,
                      backgroundColor: globals.themeColours[colourIndex],
                    ),
                    body: Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: OurContainer(
                          primaryColour: Colors.white54,
                          secondaryColour: globals.themeColours[colourIndex],
                          child: ListView(
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.edit,size: 90,)
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 18,),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: <Widget>[
                                      Form(
                                          key: _emailKey,
                                          child: TextFormField(
                                            key: Key("Edit profile new email"),
                                            onChanged: (val) {
                                              setState(() {
                                                newEmail = val;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.only(bottom: 5),
                                                labelText: 'Email',
                                                labelStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                hintText: 'Enter a new email',
                                                hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            validator: (val) => !(_validator
                                                    .validateEmail(val!))
                                                ? 'enter a valid email'
                                                : null,
                                          )),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(primary: globals.themeColours[colourIndex]),
                                        key: Key("Edit profile change email button"),
                                          onPressed: () async {
                                            if (_emailKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              dynamic signUpAttempt =
                                                  await _auth.updateEmail(
                                                      newEmail,
                                                      widget.oldPassword);
                                              if (signUpAttempt == true) {
                                                setState(() {
                                                  loading = false;
                                                  emailSuccess =
                                                      'Email has been updated';
                                                });
                                              }
                                            }
                                          },
                                          child: Text("Change email")),
                                      Text(emailSuccess,
                                          style: TextStyle(
                                              color: globals
                                                  .themeColours[colourIndex],
                                              fontWeight: FontWeight.bold)),
                                      Form(
                                        key: _passwordKey,
                                        child: TextFormField(
                                          key: Key("Edit profile new password"),
                                          onChanged: (val) {
                                            setState(() {
                                              newPassword = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 5),
                                              labelText: 'Password',
                                              labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintText: 'Enter a new password',
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          validator: (val) => !(_validator
                                                  .validatePassword(val!))
                                              ? 'enter a password with 6 or more characters, one symbol and a capital letter'
                                              : null,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Form(
                                        key: _confirmPasswordKey,
                                        child: TextFormField(
                                          key: Key("Edit profile new password confirmation"),
                                          onChanged: (val) {
                                            setState(() {
                                              confirmPassword = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 5),
                                              labelText: 'Confirm Password',
                                              labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintText:
                                                  'Enter the same Password to confirm.',
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          validator: (val) {
                                            if (val == newPassword) {
                                            //  print("Same");
                                              return null;
                                            } else {
                                             // print('no');
                                              return 'Enter the same password..';
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: globals.themeColours[colourIndex]),
                                          key: Key("Edit profile change password button"),
                                          onPressed: () async {
                                            if (_passwordKey.currentState!
                                                    .validate() &&
                                                _confirmPasswordKey
                                                    .currentState!
                                                    .validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              dynamic signUpAttempt =
                                                  await _auth.updatePassword(
                                                      widget.oldPassword,
                                                      newPassword);
                                              if (signUpAttempt == true) {
                                                setState(() {
                                                  loading = false;
                                                  passwordSuccess =
                                                      'Password has been updated';
                                                });
                                              }
                                            }
                                          },
                                          child: Text("Change password")),
                                      Text(
                                        passwordSuccess,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }
          return Container();
        });
  }
}
