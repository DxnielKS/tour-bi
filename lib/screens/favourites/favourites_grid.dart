import 'package:animations/animations.dart';
import 'package:bicycle_hire_app/constants/animations/container_transitions.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/screens/favourites/favourite_places/fav_places_provider.dart';
import 'package:bicycle_hire_app/screens/favourites/route_names_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FavouritesGrid extends StatefulWidget {
  const FavouritesGrid({Key? key}) : super(key: key);

  @override
  State<FavouritesGrid> createState() => _FavouritesGridGridState();
}

class _FavouritesGridGridState extends State<FavouritesGrid> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  Widget widgetCard(String title, Widget newScreen, String image) {
    return OpenContainer<bool>(
      key: Key(title),
      closedColor: Colors.transparent,
      transitionType: _transitionType,
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return newScreen;
      },
      onClosed: (bool? boo) {},
      tappable: false,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      closedElevation: 0,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return InkWellOverlay(
          openContainer: openContainer,
          height: 270,
          color: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            child: Stack(alignment: Alignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(image,
                    fit: BoxFit.cover,

                    color: Colors.black.withOpacity(0.45),
                    colorBlendMode: BlendMode.dstATop),
              ),
              Text(
                title,
                style: GoogleFonts.dellaRespira(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.9),
              ),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headline4 = Theme.of(context).textTheme.titleLarge!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
            child: OurText(text: 'Favourites',color: Colors.white, underlined: false,fontSize: 25,),
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
                  Colors.lightBlueAccent,
                  Colors.indigo,
                ],
              )
          ),
        child: SafeArea(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              widgetCard("Favourite Places", FavouritePlacesProvider(),
                  'assets/images/favourites/london_eye.jpg'),
              widgetCard("Favourite Routes", RouteNameProvider(),
                  'assets/images/favourites/bike.jpg'),
              SizedBox(
                height: MediaQuery.of(context).size.height /7,
              )
            ],
          ),
        ),
      ),
    );
  }
}
