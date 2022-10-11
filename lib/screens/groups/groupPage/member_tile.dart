import 'package:animations/animations.dart';
import 'package:avatars/avatars.dart';
import 'package:bicycle_hire_app/constants/animations/container_transitions.dart';
import 'package:bicycle_hire_app/constants/loading/loading_tile.dart';
import 'package:bicycle_hire_app/models/group_model.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/profile/profile_stream.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;


class MemberTile extends StatelessWidget {
  //const MemberTile({Key? key}) : super(key: key);

  final memberUid;

  MemberTile({this.memberUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData?>(
        initialData: UserData(uid: "", isAnon: false, age: "", firstName: ""),
        stream: DatabaseService(uid: memberUid).userData,
        builder: (context, snapshot) {
          // if (snapshot.data!.lastName! != 'default' && snapshot.data?.firstName != null) {
          //   String? fullName = snapshot.data?.firstName?.toUpperCase();
          // }

          if (snapshot.hasData) {
            if (snapshot.data?.firstName != null) {
              return BuildCard(snapshot: snapshot);
            } else {
              return Container();
            }
          }
          else {
            //print(memberUid);
            DatabaseService database = DatabaseService();
            database.removeUserFromGroup(memberUid);
            return SizedBox(height:0);
          }
        }
    );
  }
}

class BuildCard extends StatelessWidget {
  //const BuildCard({Key? key}) : super(key: key);

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  AsyncSnapshot<UserData?> snapshot;

  BuildCard({required this.snapshot});


  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    final groupData = Provider.of<GroupData?>(context);

    bool isMe = false;
    bool leader = false;

    if (userData!.uid == snapshot.data!.uid) {
      isMe = true;
      //leader = false;
    }
    if (groupData!.groupLeader == snapshot.data!.uid) {
      //isMe = true;
      leader = true;
    }

    return FutureBuilder(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> colour) {
          if (colour.hasData) {
            colourIndex = colour.data;
            return  OpenContainerWrapper(
              transitionType: _transitionType,
    closedBuilder: (BuildContext _, VoidCallback openContainer) {
      return
        InkWellOverlay(
          openContainer: openContainer,
          height: 100,
          color: globals.themeColours[colourIndex],
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                color: Colors.transparent,
                height: 100,
                width: 80,
                child: Center(
                  child: ListTile(
                            leading: CircleAvatar(
                                radius: 20,
                                child: ClipOval(
                                    child: Avatar(
                                      shape: AvatarShape.circle(24),
                                      name: snapshot.data!.firstName,
                                    )
                                )
                            ),

                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !isMe ? Text(snapshot.data!.firstName,style: TextStyle(color: globals
                        .textColours[colourIndex],fontSize: 25),) : Text(
                    "You", style: TextStyle(color: globals
                    .textColours[colourIndex],fontSize: 25),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: leader
                                  ? Icon(
                                Icons.star_outlined, color: globals.textColours[colourIndex],)
                                  : Icon(
                                Icons.star, color: Colors.transparent,),
                    ),
                  ],
                ),
              ),
            ],
          ),


        );
        // Padding(
        //   padding: EdgeInsets.only(top: 8.0),
        //   child: Card(
        //     color: globals.appBarColour[colourIndex],
        //     elevation: 15,
        //     margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        //     child: ListTile(
        //         leading: CircleAvatar(
        //             radius: 20,
        //             child: ClipOval(
        //                 child: Avatar(
        //                   shape: AvatarShape.circle(24),
        //                   name: snapshot.data!.firstName,
        //                 )
        //             )
        //         ),
        //         title: !isMe ? Text(snapshot.data!.firstName) : Text(
        //           "You", style: TextStyle(color: globals
        //             .titleColour[colourIndex]),),
        //         trailing: leader
        //             ? Icon(
        //           Icons.star_outlined, color: globals.titleColour[colourIndex],)
        //             : Icon(
        //           Icons.star, color: Colors.transparent,),
        //         onTap: () {
        //           openContainer;
        //           // Navigator.push(context, MaterialPageRoute(
        //           //     builder: (context) =>
        //           //         ProfileProvider(memberUid: snapshot.data!
        //           //             .uid,)));
        //         }
        //     ),
     //     ));
    }, onClosed: (bool? data) {  }, method:  ProfileProvider(memberUid: snapshot.data!.uid,),
            );

          }
          return LoadingTile();
        });
  }
}

//Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileProvider(memberUid: snapshot.data!.uid,)));