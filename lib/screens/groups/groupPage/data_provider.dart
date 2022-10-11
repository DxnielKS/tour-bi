import 'package:bicycle_hire_app/models/group_model.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/groups/groupPage/show_group.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class GroupDataProvider extends StatefulWidget {
  const GroupDataProvider({Key? key}) : super(key: key);

  @override
  State<GroupDataProvider> createState() => _GroupDataProviderState();
}

class _GroupDataProviderState extends State<GroupDataProvider> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);
    String group_ID = userData!.groupId.toString();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });

    return StreamProvider<GroupData?>.value(
      value: DatabaseService(groupId: group_ID).groupData,
      initialData: GroupData(groupList: []),
      child: ShowGroup(),

    );
  }
}