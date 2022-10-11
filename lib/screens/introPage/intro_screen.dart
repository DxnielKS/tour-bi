import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/screens/map/MapHome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

import '../../services/authHelpers/auth_service.dart';
import '../../services/requests/database_service.dart';
import '../../../services/globals.dart';

import 'package:permission_handler/permission_handler.dart';

class introScreen extends StatefulWidget {
  final globals.GlobalFunctions globalFunctions;
  introScreen({required this.globalFunctions});

  @override
  _introScreenState createState() => _introScreenState();
}

List<Color> themeColours = [
  Colors.lightBlueAccent,
  GFColors.DANGER,
  GFColors.INFO,
  Colors.grey,
  Colors.indigo,
  Colors.deepPurple.shade800
];
int index = 0;

class _introScreenState extends State<introScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool done = true;
  final AuthService _auth = AuthService();
  late Permission permission;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  Future<void> _onIntroEnd(context) async {
    var data = await DatabaseService(
      uid: _auth.getCurrent()?.uid,
    );
    data.updateIsNewUser();
    setState(() {});
  }

  void _listenForPermission() async {
    final status = await Permission.locationWhenInUse.status;
    print("STATUS: $status");
    setState(() {
      permissionStatus = status;
    });
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();

        break;
      case PermissionStatus.granted:
        // Do nothing

        break;

      case PermissionStatus.limited:
        // Send them to the request permission screen

        break;

      case PermissionStatus.restricted:
        // Send them to the request permission screen

        break;

      case PermissionStatus.permanentlyDenied:
        // Send them to the request permission screen

        break;
    }
  }

  Future<void> requestForPermission() async {
    final status = await Permission.locationWhenInUse.request();
    setState(() {
      permissionStatus = status;
    });
  }

  void askUserForPermissionsAgain() async {
    final status = await Permission.locationAlways.request();
  }

  @override
  void initState() {
    _listenForPermission();
    super.initState();
  }

  Widget _buildFullscreenImage(String assetName) {
    return Image.asset(
      'assets/images/introPage/$assetName',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/introPage/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    PageDecoration pagedecor(int index) {
      return PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: themeColours[index],
        imagePadding: EdgeInsets.zero,
      );
    }

    return FutureBuilder(
        future: widget.globalFunctions.getIsNewUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //print("hello1");
          if (snapshot.hasData) {
            if (snapshot.data) {
              return IntroductionScreen(
                //isBottomSafeArea: true,
                //globalBackgroundColor: appBarColour[index],
                key: introKey,
                globalHeader: Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      child: Text(""),
                    ),
                  ),
                ),
                pages: [
                  PageViewModel(
                    title: "Welcome to TourBi",
                    body:
                        "This app has been designed to organise and navigate your way around the city",
                    image: _buildImage('bikeman.png'),
                    decoration: pagedecor(0),
                  ),
                  PageViewModel(
                    title: "Explore london with the Boris-Bikes!",
                    body: "Allow us to take you to the closest bikes available",
                    image: _buildImage('london.png'),
                    decoration: pagedecor(1),
                  ),
                  PageViewModel(
                    title: "Create Groups and cycle with friends and family",
                    body:
                        "gather friends and family alike and tour london using a simple 4 digit code to sync up",
                    image: _buildImage('group_intro.png'),
                    decoration: pagedecor(2),
                  ),
                  PageViewModel(
                      image: _buildImage('turnByTurn_intro.png'),
                      title: "With turn by turn navigation",
                      body:
                          "Navigation will be displayed on all screens to make sure everyone can safely arrive at the destination!",
                      decoration: pagedecor(3)),
                  // PageViewModel(
                  //
                  //   title: "IDK",
                  //   body: "ur funny 5",
                  //   //image: _buildImage('img2.jpg'),
                  //   decoration: pagedecor(4),
                  // ),
                ],
                onDone: () => _onIntroEnd(context),
                //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
                showSkipButton: true,
                skipOrBackFlex: 0,
                nextFlex: 0,
                showBackButton: false,
                //rtl: true, // Display as right-to-left
                //back: const Icon(Icons.arrow_back),
                skip: const Text('Skip',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                next: const Icon(Icons.arrow_forward),
                done: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                curve: Curves.fastLinearToSlowEaseIn,
                controlsMargin: const EdgeInsets.all(16),
                controlsPadding: kIsWeb
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                dotsDecorator: const DotsDecorator(
                  size: Size(10.0, 10.0),
                  color: Color(0xFFBDBDBD),
                  activeSize: Size(22.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                dotsContainerDecorator: const ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              );
            } else if (permissionStatus.isGranted) {
              return MapHome();
            } else {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Allow permissions'),
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "To use this app you will need\n"
                          "to go to settings and enable\n"
                          "Location to 'Always'\n\n"
                          "You may need to restart the\n"
                          "app.",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          child: const Text('Go to app settings'),
                          onPressed: () {
                            openAppSettings();
                          },
                        ),
                      ),
                    ],
                  ));
            }
          }
          return Loading();
        });
  }
}
