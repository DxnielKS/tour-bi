
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import "package:flutter/material.dart";
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';

import 'activity_list.dart';
import 'journey_activity_list.dart';


class ActivitiesProvider extends StatefulWidget {

  @override
  _ActivitiesProviderState createState() => _ActivitiesProviderState();
}

class _ActivitiesProviderState extends State<ActivitiesProvider> {
  final AuthService _auth = AuthService();
  String? groupID = "";
  bool journeyStarted = false;
  String leaderID = "";

  @override
  Widget build(BuildContext context) {
    final TextStyle headline4 = Theme.of(context).textTheme.titleLarge!;
    //get current users group id
    _auth.getCurrentUserGroupId().then((value) {
      if (!mounted) return;
      setState(() {
        groupID = value;
      });
    });
    if(groupID != ""){
      //get whether journey has started if in a group
      DatabaseService(uid: _auth.getCurrent()?.uid,groupId: groupID).getJourneyStarted().then((value) {
        if (!mounted) return;
        setState(() {
          journeyStarted = value;
        });
      });
      //get group leader id if in a group
      DatabaseService(uid: _auth.getCurrent()?.uid, groupId: groupID).getLeaderUID().then((value) {
        if (!mounted) return;
        setState(() {
          leaderID = value;
        });
      });
    }
    return (groupID != "" && journeyStarted) ? 
    activityList("Group Leader Activity List", leaderID, JourneyActivityList()) : activityList("Activity List", _auth.getCurrent()?.uid, ActivityList());
  }

  Widget activityList(String text, String? uid, Widget newScreen){
    return StreamProvider<List<Place>?>.value(
      value: DatabaseService(uid: uid).places,
      initialData: [],
      child:Scaffold(
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title:  OurText(
            text: text,
            fontSize: 25,
            color: Colors.white,
            underlined: false,
            ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Colors.green,
                    Colors.indigo,
                  ],
                )
            ),child: SafeArea(child: newScreen))
      )
    );
  }
}