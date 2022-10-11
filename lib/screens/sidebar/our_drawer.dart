import 'package:avatars/avatars.dart';
import 'package:bicycle_hire_app/models/drawer_item.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/getStarted/get_started.dart';
import 'package:bicycle_hire_app/screens/groups/groupAuth/group_provider.dart';
import 'package:bicycle_hire_app/screens/profile/profile_stream.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_items.dart';
import 'package:bicycle_hire_app/screens/sidebar/sidebar_navigation.dart';
import 'package:bicycle_hire_app/services/authHelpers/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;


class OurDrawer extends StatefulWidget {
  @override
  State<OurDrawer> createState() => _OurDrawerState();
}

class _OurDrawerState extends State<OurDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  double? _width = null;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;
    //bool showtext = false;
    //final isAnon = userData!.isAnon!;
    //final bool isAnon = Firebase.auth.currentUser.isAno
    double? getWidth() {
      if (isCollapsed) {
        _width = 80;
      } else {
        _width = 300;
      }
      return _width;
    }

    int colourIndex = 4;

    return FutureBuilder<int>(
        future: globals.getTheme(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            colourIndex = snapshot.data;
            return AnimatedContainer(
              width: _width = getWidth() as double?,
              duration: Duration(milliseconds: 250),
              child: Drawer(
                child: Container(
                  color: globals.textColours[colourIndex],
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    globals.themeColours[colourIndex]
                                        .withOpacity(0.8),
                                    BlendMode.hardLight),
                                image: AssetImage(
                                  "assets/images/mapIcons/london_sideBar.jpg"
                                ),
                                fit: BoxFit.cover,
                                opacity: 20)),
                        padding:
                            EdgeInsets.symmetric(vertical: 12).add(safeArea),
                        height: 140,
                        width: double.infinity,
                        //decoration:,
                        //color: globals.appBarColour[colourIndex],
                        child: buildHeader(isCollapsed, userData?.firstName,
                            userData?.lastName),
                      ),
                      buildList(items: SidebarList, isCollapsed: isCollapsed),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 400,
                          child: Column(
                            children: [
                              userData!.isAnon? buildList(
                                      indexOffSet: SidebarList.length,
                                      items: SidebarAnon,
                                      isCollapsed: isCollapsed)
                                  : buildList(
                                      indexOffSet: SidebarList.length,
                                      items: SidebarSecondList,
                                      isCollapsed: isCollapsed),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      buildCollapseIcon(context, isCollapsed),
                      // IconButton(onPressed: () {setState(() =>
                      //   _width = 400);
                      // }, icon: Icon(Icons.star, color: Colors.red,)),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffSet = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () {
              selectItem(context, index + indexOffSet);
            },
          );
        },
      );

  Widget? selectItem(BuildContext context, int index) {
    final userData = Provider.of<UserData?>(context, listen: false);
    final navigateTo = (page) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => page));
    //Navigator.of(context).pop();
    switch (index) {
      case 0:
        navigateTo(GroupProvider());
        break;
      case 1:
        navigateTo(GetStarted());
        break;
      // navigateTo(Scaffold(
      //   appBar: AppBar(
      //     title: Text('placeholder')
      case 2:
        userData!.isAnon
            ? AuthService().signOut(userData.groupId.toString())
            : navigateTo(ProfileProvider(
                memberUid: userData.uid,
              ));
        break;
      case 3:
        AuthService().signOut(userData!.groupId.toString());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
    bool showText = false,
  }) {

    final color = Colors.black;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              key:Key(text),
              leading: leading,
              title: Text(
                    !showText? text: "",
                    style: TextStyle(color: color, fontSize: 16),
                  ),
              onTap: onClicked,
            ),
    );
  }

  Widget buildHeader(bool isCollapsed, String? name, String? lastName) {
    String fullName = '';
    if (lastName != null && name != null) {
      fullName = name.toUpperCase() + " " + lastName.toUpperCase();
    } else if (lastName == null && name != null) {
      fullName = name.toUpperCase();
    }

    return isCollapsed
        ? CircleAvatar(
            radius: 25,
            child: ClipOval(
                child: Avatar(
              shape: AvatarShape.circle(24),
              name: fullName,
            )))
        : Row(
            children: <Widget>[
              const SizedBox(width: 25),
              CircleAvatar(
                  radius: 24,
                  child: ClipOval(
                      child: Avatar(
                    shape: AvatarShape.circle(24),
                    name: fullName,
                  ))),
              //FlutterLogo(size: 48),
              const SizedBox(width: 16),
              Text(
                "$name",
                style: GoogleFonts.ramaraja(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, offset: Offset(-2,2)),Shadow(color: Colors.black, offset: Offset(-2,-2)),Shadow(color: Colors.black, offset: Offset(-2,0)),Shadow(color: Colors.black, offset: Offset(2,2)),Shadow(color: Colors.black, offset: Offset(2,-2)),Shadow(color: Colors.black, offset: Offset(2,0)),Shadow(color: Colors.black, offset: Offset(0,-2)),Shadow(color: Colors.black, offset: Offset(0,2))] ))
            ],
          );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed
        ? Icons.arrow_forward_ios_rounded
        : Icons.arrow_back_ios_new_rounded;

    bool? getWidth() {
      if (isCollapsed) {
        _width = 80;
      } else {
        _width = 400;
      }
    }

    return InkWell(
        onTap: () {
          final provider =
              Provider.of<NavigationProvider>(context, listen: false);
          //isCollapsed = !isCollapsed;
          //provider.toggleIsCollapsed();
          setState(() {
             _width =  getWidth() as double?;
             provider.toggleIsCollapsed();

          });
        },
        child: Container(
          //alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
          width: isCollapsed ? double.infinity : size,
          height: size,
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ));
  }
}
