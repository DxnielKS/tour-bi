import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    required this.onClosed,
    required this.method,
  });

  final Widget method;

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool?> onClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedColor: Colors.transparent,
      closedElevation: 0,
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return method;
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class InkWellOverlay extends StatelessWidget {
  const InkWellOverlay({
    this.openContainer,
    this.height,
    this.child,
    required this.color
  });
 final Color color;
  final VoidCallback? openContainer;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(23.0),
          color: color,
          elevation: 7,
          child: InkWell(
            highlightColor: color,
            onTap: openContainer,
            child: child,
          ),

        ),
      ),
    );
  }
}


