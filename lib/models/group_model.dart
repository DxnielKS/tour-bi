import 'package:bicycle_hire_app/models/user_account.dart';

class Group {
  String? groupLeader;
  List<String> groupList;
  String? groupID;

  Group({this.groupLeader, required this.groupList, this.groupID});

  void addMember(String? newMember) {
    if (checkListItem(newMember) || groupLeader == newMember) {
      //print('Group already has member!');
    } else {
      groupList.add(newMember.toString());
    }
  }

  void removeMember(String? member) {
    if (checkListItem(member)) {
      groupList.remove(member);
    } else {
      //print('Member cannot be removed as it is not in group.');
    }
  }

  void changeLeader(String? newLeader) {
    groupLeader = newLeader;
  }

  bool checkListItem(String? member) {
    if (groupList.contains(member)) {
      return true;
    } else {
      return false;
    }
  }
}

class GroupData {
  String? groupLeader;
  List<dynamic> groupList;
  String? joinCode;
  String? groupName;
  bool? journeyStarted;

  GroupData({this.groupLeader, required this.groupList, this.joinCode, this.groupName, this.journeyStarted});
}
