class Account {
  final String? uid;
  String? firstName;
  String? lastName;
  bool? inGroup;
  String? groupId;

  Account({required this.uid, required this.firstName, required this.inGroup});
}

class AnonAccount {
  final String? uid;
  final String? nickname;
  bool? inGroup;

  AnonAccount({this.uid, this.inGroup, this.nickname});
}

// class UserData {
//   final String? uid;
//   final String? firstName;
//   final String? lastName;
//   bool inGroup;
//
//   UserData(
//       {required this.uid,
//       required this.firstName,
//       required this.lastName,
//       required this.inGroup});
// }

class UserData {
  String uid;
  String firstName;
  String? lastName;
  String? groupId;
  String age;
  bool isAnon;

  UserData(
      {required this.age ,required this.uid,required this.firstName, this.groupId, required this.isAnon, this.lastName});
}
