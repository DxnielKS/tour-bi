import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/screens/profile/profile.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

class ProfileProvider extends StatefulWidget {
  String memberUid;
  ProfileProvider({required this.memberUid});

  @override
  State<ProfileProvider> createState() => _ProfileProviderState();
}

class _ProfileProviderState extends State<ProfileProvider> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account?>(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });

    return StreamProvider<UserData?>.value(
      value: DatabaseService(uid: user?.uid).userData,
      initialData: UserData(uid: "",isAnon: false,age: "",firstName: ""),
      child: ViewProfile(memberUid: widget.memberUid,),
    );
  }
}