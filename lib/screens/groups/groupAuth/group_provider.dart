import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/groups/group_wrapper.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class GroupProvider extends StatefulWidget {
  const GroupProvider({Key? key}) : super(key: key);

  @override
  State<GroupProvider> createState() => _GroupProviderState();
}

class _GroupProviderState extends State<GroupProvider> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account?>(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });

    return StreamProvider<UserData?>.value(
      value: DatabaseService(uid: user?.uid).userData,
      initialData: UserData(uid: "",isAnon: false,age: "",firstName: ""),
      child: GroupWrapper(),
    );
  }
}
