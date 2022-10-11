import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'groupAuth/group_application.dart';
import 'groupPage/data_provider.dart';


class GroupWrapper extends StatelessWidget {
  const GroupWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    //final AnonUser provider
    if (user?.groupId == '') {
      //or anonuser is not null
      // if the user is not logged in
      return GroupApplication(); // REMOVE THIS AND REPLACE WITH ANON GROUP VIEW
    } else {
      // if the user is logged in
      return GroupDataProvider(); // REPLACE WITH LOGGED IN GROUP VIEW
    }
  }
}
