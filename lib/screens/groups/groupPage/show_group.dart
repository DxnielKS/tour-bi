import 'package:bicycle_hire_app/constants/customWidgets/our_container.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/models/group_model.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'members_list.dart';

class ShowGroup extends StatefulWidget {
  const ShowGroup({Key? key}) : super(key: key);

  @override
  _ShowGroupState createState() => _ShowGroupState();
}

class _ShowGroupState extends State<ShowGroup> {
  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    final groupData = Provider.of<GroupData>(context);
    String joinCode = groupData.joinCode.toString();
    String groupName = groupData.groupName.toString();

    void _LeaveGroup(BuildContext context) async {
      String groupID = userData!.groupId.toString();
      if (userData.uid == groupData.groupLeader) {
        // If group leader leaves then disband group
        DatabaseService(uid: userData.uid).disbandGroup(groupID);
      } else {
        // if group member leaves then remove user from group
        DatabaseService(uid: userData.uid).removeUserFromGroup(groupID);
      }
    }

    return FutureBuilder(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
            return Scaffold(
              backgroundColor: globals.themeColours[colourIndex],
              appBar: AppBar(
                backgroundColor: globals.themeColours[colourIndex],
                elevation: 0,
                foregroundColor: globals.textColours[colourIndex],
                title: OurText(
                  color: globals.textColours[colourIndex],
                  text: 'Group Page',
                  fontSize: 25,
                  underlined: false,
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      height: 50,
                      width: 400,
                      alignment: Alignment.center,
                      child: OurText(
                        text: '$groupName',
                        fontSize: 34,
                        color: Colors.white,
                        underlined: true,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 8),
                        height: 50,
                        width: 400,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OurText(
                              text: 'Join Code: ',
                              color: Colors.white,
                              underlined: false,
                              fontSize: 24,
                            ),
                            OurText(
                              text: '$joinCode',
                              color: Colors.white,
                              underlined: true,
                              fontSize: 24,
                            ),
                          ],
                        )),
                    // Container(
                    //   padding: EdgeInsets.only(top: 15),
                    //   height: 30,
                    //   child: Text(groupData.joinCode.toString()),
                    // ),
                    OurContainer(
                      primaryColour: Colors.white54,
                      secondaryColour: globals.themeColours[colourIndex],
                      child: SingleChildScrollView(
                        child: Container(
                            height: 450, width: 320, child: MemberList()),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(20),
                        backgroundColor:MaterialStateProperty.all(GFColors.DANGER),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.black,width: 2)
                              )
                          )
                      ),
                        onPressed: () async {
                          _LeaveGroup(context);
                        },
                        icon: Icon(Icons.logout),
                        label: Text(
                          'Leave Group',
                          style: TextStyle(
                              color: globals.textColours[colourIndex]),
                        ))
                  ],
                ),
              ),
            );
          }
          return Loading();
        });
  }
}
//571c
