import 'package:bicycle_hire_app/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'member_tile.dart';
import 'package:auto_animated/auto_animated.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {

    final groupData = Provider.of<GroupData?>(context);

    return ListView.builder(
      itemCount: groupData!.groupList.length,
      itemBuilder: (context, index) {
        return MemberTile(memberUid: groupData.groupList[index].toString());
      },
    );
  }
}
