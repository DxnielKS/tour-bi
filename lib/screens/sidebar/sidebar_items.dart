//intialise all the elements (rows) required for the sidebar into a list
import 'package:bicycle_hire_app/models/drawer_item.dart';
import 'package:flutter/material.dart';
// import 'package:styled_widget/styled_widget.dart';

final SidebarList = [
  DrawerItem(title: 'Groups', icon: Icons.group),
];

final SidebarSecondList = [
  DrawerItem(title: 'Get Started', icon: Icons.school),
  DrawerItem(title: 'Profile', icon: Icons.account_circle),
  DrawerItem(title: 'Log Out', icon: Icons.logout),
];

final SidebarAnon = [
  DrawerItem(title: 'Get Started', icon: Icons.school),
  //DrawerItem(title: 'Profile', icon: Icons.account_circle),
  DrawerItem(title: 'Log Out', icon: Icons.logout),
];
