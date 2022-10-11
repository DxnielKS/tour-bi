//Create Items to be added to the side bar (icon and string)

import 'package:flutter/material.dart';

class DrawerItem{
  final String title;
  final IconData icon;
  Key key;

  DrawerItem({
    required this.title,
    required this.icon,
}) : key = Key(title);
}