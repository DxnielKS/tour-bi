import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;

import 'our_drawer.dart';

class DrawerProvider extends StatefulWidget {
  const DrawerProvider({Key? key}) : super(key: key);

  @override
  State<DrawerProvider> createState() => _DrawerProviderState();
}

class _DrawerProviderState extends State<DrawerProvider> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = false;
    });
    final user = Provider.of<Account?>(context);

    return StreamProvider<UserData?>.value(
      value: DatabaseService(uid: user?.uid).userData,
      initialData: UserData(uid: "", isAnon: true, firstName: '',age: "",),
      child: OurDrawer(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      globals.show.value = true;
    });
  }
}
