import 'package:avatars/avatars.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/introPage/intro_screen.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

import 'edit_login_details.dart';
import 'edit_profile.dart';

class ViewProfile extends StatefulWidget {
  String memberUid;

  ViewProfile({required this.memberUid});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late TextEditingController textController;
  // _getRequests() async {}
  String email = '';

  // late String firstName;
  // late String surname;
  // late String age;
  //  late String fullname;
  final AuthService _auth = AuthService();
  String error = "";
  bool loading = false;
  int colourIndex = 0;

  @override
  void initState() {
    fetch(_auth);
    super.initState();
    textController = TextEditingController();
  }

  Future onGoBack() async {
    var isAnon = await _auth.getCurrentUserStatus().then((value) => value);
    if (!isAnon!) {
      email = await _auth.getCurrentUserEmail() as String;
    } else {
      email = "Anon";
    }
    // firstName = await _auth.getCurrentUserfirstName() as String;
    // surname = await _auth.getCurrentUserLastName() as String;
    // age = await _auth.getCurrentUserAge() as String;
    // fullname = firstName.toUpperCase() + " " + surname.toUpperCase();
    // // //profile = Avatar(name: fullname, placeholderColors: [
    // //   Color(0xFFFF0000),
    // //   Color.fromARGB(255, 89, 0, 255),
    // //   //...
    // // ]);

    setState(() {});
  }

  Future<void> fetch(AuthService auth) async {
    var isAnon = await _auth.getCurrentUserStatus().then((value) => value);
    if (!isAnon!) {
      email = await _auth.getCurrentUserEmail() as String;
    } else {
      email = "Anon";
    }

    //   firstName = await _auth.getCurrentUserfirstName() as String;
    //   surname = await _auth.getCurrentUserLastName() as String;
    //   age = await _auth.getCurrentUserAge() as String;
    //   fullname = firstName.toUpperCase() + " " + surname.toUpperCase();
    //   profile = Avatar(name: fullname, placeholderColors: [
    //     Color(0xFFFF0000),
    //     Color.fromARGB(255, 89, 0, 255),
    //     //...
    //   ]);
    setState(() {
      loading = false;
    });
  }

  Future confirmPassword(String newPassword) async {
    var confirmation = await _auth.LogInWithEmail(email, newPassword);
    if (confirmation == null) {
      setState(() {
        error = 'Incorrect Password';
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  editLoginDetails(oldPassword: newPassword)))
          .then((value) async {
        await onGoBack();
        setState(() {});
      });
    }
  }

  Future enterPassword() => showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Enter Password'),
              content: TextField(
                controller: textController,
                key: Key("Edit log in Enter password"),
                obscureText: true,
                decoration: InputDecoration(
                    hintText:
                    'Enter current password'),
              ),
              actions: [
                TextButton(
                  child: OurText(text:"Confirm",color: GFColors.ALT,underlined: false,fontSize: 20,),
                  onPressed: () async {
                    var str = textController.text;
                    await confirmPassword(str);
                    textController.clear();
                    setState(() {});
                  },
                ),
                SizedBox(height: 10,)
              ],
            );
          },
        );
      });

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    return StreamBuilder<UserData?>(
        initialData: UserData(uid: "", isAnon: false, age: "", firstName: ""),
        stream: DatabaseService(uid: widget.memberUid).userData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
          return FutureBuilder(
              future: globals.getTheme(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  bool isMe = false;
                  bool isAnon = userSnapshot.data.isAnon;
                  if (snapshot.hasData) {
                    if (userData!.uid == userSnapshot.data.uid) {
                      isMe = true;
                    }
                    colourIndex = snapshot.data;
                    return loading
                        ? Loading()
                        : Container(
                      child: Scaffold(
                          backgroundColor:
                          globals.themeColours[colourIndex],
                          appBar: AppBar(
                            title: OurText(
                              text: 'Profile',
                              color: Colors.white,
                              fontSize: 25,
                              underlined: false,
                            ),
                            centerTitle: true,
                            backgroundColor:
                            globals.themeColours[colourIndex],
                            elevation: 0.0,
                          ),
                          body: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  30.0, 40.0, 30.0, 0.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                      child: Avatar(
                                          name: userSnapshot
                                              .data!.firstName,
                                          backgroundColor: globals
                                              .themeColours[colourIndex],
                                          placeholderColors: [
                                            colourIndex == 5
                                                ? globals.themeColours[
                                            colourIndex - 1]
                                                : globals.themeColours[
                                            colourIndex + 1],
                                            //globals.titleColour[colourIndex],
                                            //...
                                          ])),
                                  Divider(
                                      height: 30,
                                      color: globals
                                          .textColours[colourIndex]),
                                  OurText(
                                    text: 'Name',
                                    fontSize: 18,
                                    color: Colors.white,
                                    underlined: false,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  OurText(
                                    text: userSnapshot.data!.firstName
                                        .toString(),
                                    color: Colors.amberAccent.shade200,
                                    underlined: false,
                                    fontSize: 40,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  OurText(
                                    text: 'Surname',
                                    color: Colors.white,
                                    fontSize: 18,
                                    underlined: false,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  !isAnon
                                      ? //!snapshot.data.isAnon?
                                  OurText(
                                    text: userSnapshot
                                        .data!.lastName
                                        .toString(),
                                    color:
                                    Colors.amberAccent.shade200,
                                    underlined: false,
                                    fontSize: 40,
                                  )
                                      : OurText(
                                    text: "Please Sign up",
                                    color:
                                    Colors.amberAccent.shade200,
                                    fontSize: 40,
                                    underlined: false,
                                  ),
                                  SizedBox(height: 20),
                                  isMe
                                      ? Row(
                                    children: <Widget>[
                                      Icon(Icons.email,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      OurText(
                                        text: !isAnon
                                            ? email
                                            : "Anonymous User",
                                        color: Colors
                                            .amberAccent.shade200,
                                        fontSize: 20,
                                        underlined: false,
                                      )
                                    ],
                                  )
                                      : SizedBox(
                                    height: 200,
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  isMe && !isAnon
                                      ? //snapshot.data.isAnon?
                                  ProfileButtons(
                                      firstName: userSnapshot
                                          .data!.firstName,
                                      email: email,
                                      surname:
                                      userSnapshot.data!.lastName,
                                      age: userSnapshot.data!.age,
                                      fullname: userSnapshot
                                          .data!.firstName
                                          .toString() +
                                          " " +
                                          userSnapshot.data!.lastName
                                              .toString(),
                                      onGoBack: onGoBack,
                                      enterPassword: enterPassword)
                                      : SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          )),
                    );
                  } else {
                    return Loading();
                  }
                }
                return Loading();
              });
        });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }
}

class ProfileButtons extends StatefulWidget {
  String email;
  String firstName;
  String surname;
  String age;
  String fullname;
  Function onGoBack;
  Function enterPassword;

  ProfileButtons(
      {required this.firstName,
        required this.email,
        required this.surname,
        required this.age,
        required this.fullname,
        required this.onGoBack,
        required this.enterPassword});

  @override
  State<ProfileButtons> createState() => _ProfileButtonsState();
}

class _ProfileButtonsState extends State<ProfileButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent, elevation: 30),
            key: Key("Edit profile button"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => editProfile(
                          email: widget.email,
                          firstName: widget.firstName,
                          surname: widget.surname,
                          age: widget.age))).then((_) async {
                await widget.onGoBack();
                setState(() {});
              });
            },
            child: OurText(
              text: "Edit Profile",
              color: Colors.white,
              fontSize: 18,
              underlined: false,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent, elevation: 30),
            key: Key("Edit log in details button"),
            onPressed: () {
              widget.enterPassword().then((value) {
                setState(() {});
              });
            },
            child: OurText(
              text: "Edit Log In Details",
              color: Colors.white,
              fontSize: 18,
              underlined: false,
            ),
          ),
        ),
      ],
    );
  }

}