import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 61, 131, 255),
      child: Center(
        child: Stack(
          children:[
        SpinKitRing(
        color: Colors.black45,
          size: 150.0,
          lineWidth: 4,
        ),
            Center(
              child: Container(
                height: 90,
                child: Image.asset('assets/images/logo_nobg.png'),
              ),
            )
          ]
          ),
        ),
    );
  }
}