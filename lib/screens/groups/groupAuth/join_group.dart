import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_hire_app/services/requests/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bicycle_hire_app/models/user_account.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final _formKey = GlobalKey<FormState>();
  String groupID = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  String getUser() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }

  //final userid = user.uid;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData?>(context);

    void _JoinGroup(BuildContext context, String groupID) async {
      DatabaseService(uid: userData?.uid).addUserToGroup(groupID);
    }

    // return Scaffold(
    //   backgroundColor: Colors.lightBlueAccent,
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0.0,
    //     //title: Text('Create a group'),
    //     //actions: [],
    //   ),
    //   body:
     return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.group_add),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 5.0),
                    ),
                    hintText: "Group Code",
                    contentPadding: EdgeInsets.all(20),),

                  validator: (val) => val!.isEmpty ? 'Enter group code' : null,
                  onChanged: (val) {
                    setState(() {
                      groupID = val;
                    });
                  }),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[600])),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _JoinGroup(context, groupID);
                  }
                },
                child: Text(
                  'Join',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    //   ),
    // );
  }
}
