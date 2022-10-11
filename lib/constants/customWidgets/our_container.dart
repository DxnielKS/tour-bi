import 'package:flutter/material.dart';

class OurContainer extends StatelessWidget {
  final Widget? child;

  Color secondaryColour;

  Color primaryColour;

  OurContainer({Key? key, this.child,required this.primaryColour, required this.secondaryColour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(4.0, 4.0))
          ]),
      child: child,
    );
  }
}
