import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class OurText extends StatelessWidget {

  final Widget? child;
  final String text;
  final double? fontSize;
  final Color color;
  bool underlined = false;

  OurText({Key? key, this.child, required this.text,this.fontSize,required this.color, required this.underlined}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
          decoration: underlined? TextDecoration.underline : null,

    ),
    textAlign: TextAlign.center,
    );
  }
}


class CrossedText extends StatelessWidget {

  final Widget? child;
  final String text;
  final double? fontSize;
  final Color color;
  bool crossed = false;

  CrossedText({Key? key, this.child, required this.text,this.fontSize,required this.color, required this.crossed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        decoration: crossed ? TextDecoration.lineThrough: null,

      ),
      textAlign: TextAlign.center,
    );
  }
}