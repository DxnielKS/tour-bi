import 'package:animations/animations.dart';
import 'package:bicycle_hire_app/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:getwidget/colors/gf_color.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    PageDecoration pagedecor() {
      return PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: GFColors.INFO,
        imagePadding: EdgeInsets.zero,
      );
    }

    return
        // FloatingActionButton(
        //   onPressed: (() {}),
        //   child: Icon(Icons.backspace),
        // ),
        Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GFColors.INFO,
      ),
      body: SafeArea(
        child: IntroductionScreen(
          //isBottomSafeArea: true,
          globalBackgroundColor: GFColors.INFO,
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
              image: Image.asset('assets/images/getStarted/bikepointdemo.jpeg'),
              decoration: pagedecor(),
            ),
            PageViewModel(
              title: "Search",
              bodyWidget: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/firstdemo.png',
                        width: 190,
                        scale: 0.1,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 200,
                        child: Text(
                          'There is a search bar below in the bottom bar that when selected, will allow the users to search for locations in London to visit. When searched, what will display is a markeron the displayed map to the location.  ',
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/seconddemo.png',
                        width: 190,
                        scale: 0.1,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: pagedecor(),
            ),
            PageViewModel(
              title: 'Groups',
              decoration: pagedecor(),
              bodyWidget: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/thirddemo.png',
                      width: 190,
                      scale: 0.1,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 420,
                      child: Text(
                        'If you would like to join or create a group to travel with others, you can do so by clicking the groups button on the sidebar. Please note that anonymous users cannot make groups. You can join a group if you enter the generated random 4 character code into the join group form. You may leave at anytime but note that as a group leader, if you leave a group, you will delete the group and all users will be left without a group. In addition if an anonymous user joins a group, if he signs out he will automatically be removed from the group. You can also visit the profile of any member in your group.',
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/fourthdemo.png',
                      width: 190,
                      scale: 0.1,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
            PageViewModel(
              title: "Profile",
              decoration: pagedecor(),
              bodyWidget: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/fifthdemo.png',
                        width: 190,
                        scale: 0.1,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 200,
                        child: Text(
                            'From the sidebar you can go to a profile page where you can view your profile details. You can edit your general profile details or your actual log in details as shown below. Please note that in order to change your log in details you must confirm your current password, and if you wanna change your password.'),
                        color: Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/sixthdemo.png',
                        width: 190,
                        scale: 0.1,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onDone: () => Center(),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: false,
          //rtl: true, // Display as right-to-left
          //back: const Icon(Icons.arrow_back),
          skip: const Text(
            'Skip',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 41, 40, 40)),
          ),
          next: const Icon(Icons.arrow_forward),
          done: const Text('', style: TextStyle(fontWeight: FontWeight.w600)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color.fromARGB(255, 22, 163, 173),
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
        ),
      ),
    );
  }
}
