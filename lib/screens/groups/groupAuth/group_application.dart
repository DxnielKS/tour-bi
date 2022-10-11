import 'package:bicycle_hire_app/constants/customWidgets/our_container.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:bicycle_hire_app/services/requests/mapbox_cycling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

import 'join_group.dart';

class GroupApplication extends StatefulWidget {
  const GroupApplication({Key? key}) : super(key: key);

  @override
  _GroupApplicationState createState() => _GroupApplicationState();
}

class _GroupApplicationState extends State<GroupApplication> {
  final _formKey = GlobalKey<FormState>();
  String groupName = '';
  int colourIndex = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUser() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    // here you write the codes to input the data into firestore
  }

  //final userid = user.uid;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    //final TextStyle headline4 = Theme.of(context).;

    return FutureBuilder(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
            return Scaffold(
              backgroundColor: globals.themeColours[colourIndex],
              appBar: AppBar(
                backgroundColor: globals.themeColours[colourIndex],
                elevation: 0.0,
                //title: Text('Create a group'),
                //actions: [],gi
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                width: 750,
                height: 600,
                child: SingleChildScrollView(
                  child: OurContainer(
                    primaryColour: Colors.white54,
                    secondaryColour: globals.themeColours[colourIndex],
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 40,
                            width: 400,
                            alignment: Alignment.center,
                            child: !userData!.isAnon ? CrossedText(
                              crossed: false,
                              text: "Create a Group",
                              color: Colors.black,
                              fontSize: 34,
                            ): CrossedText(
                              crossed: true,
                              text: "Create a Group",
                              color: Colors.black,
                              fontSize: 34,
                        ),
                          )
                        ),
                        CreateGroupForm(),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            height: 40,
                            width: 400,
                            alignment: Alignment.center,
                            child: OurText(
                              underlined: false,
                              text: "Join Group",
                              fontSize: 34,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        JoinGroup(),
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

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({Key? key}) : super(key: key);

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  String groupName = '';
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);

    void _createGroup(BuildContext context, String groupName) async {
      DatabaseService(uid: userData?.uid).createGroup(groupName);
    }

    if (userData!.isAnon == false) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            TextFormField(
                key: Key("Group name text field"),
                decoration: InputDecoration(
                    hintText: 'Group Name',
                    icon: Icon(Icons.group),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    )),
                validator: (val) => val!.isEmpty ? 'Enter a group name' : null,
                onChanged: (val) {
                  setState(() {
                    groupName = val;
                  });
                }),
            SizedBox(height: 20.0),
            ElevatedButton(
              key: Key("Create group button"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green[600])),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _createGroup(context, groupName);
                }
              },
              child: Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 18.0,
          ),
          Text('Make an account to make a group!',
              textScaleFactor: 1.5,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }
  }
}

