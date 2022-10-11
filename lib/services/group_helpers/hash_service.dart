import 'package:uuid/uuid.dart';

String getHashID(String documentID) {
  try {
    var uuid = const Uuid(); // initialise id generator
    return uuid
        .v1()
        .substring(0, 4); // generate time based ID and slice first 5 characters
  } catch (e) {
    // print(e);
  }
  return '';
}
