import 'dart:math';
import 'package:bicycle_hire_app/models/group_model.dart';
import 'package:bicycle_hire_app/services/group_helpers/hash_service.dart';
import 'package:bicycle_hire_app/models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_hire_app/models/Place.dart';
import 'package:bicycle_hire_app/models/Route.dart' as RouteModel;

class DatabaseService {
  final String? uid;
  final String? groupId;
  DatabaseService({this.uid, this.groupId});

  //collection references
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String? lastName, String age,
      String inGroup, bool anon, int themeIndex) async {
    return await userCollection.doc(uid).set({
      'Firstname': name,
      'Surname': lastName,
      'Age': age,
      'groupId': inGroup,
      'isAnon': anon,
      'Theme': themeIndex,
      "isNewUser" : true,
    });
  }

  Future updateUserThemeData(int themeIndex) async {
    await userCollection.doc(uid).update({
      'Theme': themeIndex // update foreign key in user model
    });
  }
  Future updateIsNewUser() async {
    await userCollection.doc(uid).update({
      'isNewUser': false // update foreign key in user model
    });
  }

  Future<int> getUserGroupSize() async {
    var userGroupID = await userCollection.doc(uid).get().then((value) => value["groupId"]);
    if(userGroupID == ""){
      return 1;
    } else {
      var userIDS = await groupCollection.doc(userGroupID).get()
          .then((value) => value["listOfUsers"]);
      var userIDList = List<String>.from(userIDS);
      try{
        return userIDList.length;
      } catch(e){
        return 1;
      }
    }
  }

  // Future updateGroupData(String? leader, List<String>? groupList, String? joinID) async {
  //   return await userCollection.doc(uid).set({
  //     'Leader'
  //   });
  // }

  // Future updateRouteHistoryData(List<String> places) async{
  //   return await userCollection.doc(uid).collection("RouteHistory").doc().set({
  //     "Places":places
  //   });
  // }

  Future updateRouteData(RouteModel.Route route) async {
    return await userCollection
        .doc(uid)
        .collection("Routes")
        .doc(route.name)
        .set(route.toJson());
  }

  Future deletePlaceData(String placesId) async {
    return userCollection.doc(uid).collection("Places").doc(placesId).delete();
  }

  Future deleteFavPlaceData(String placesId) async {
    return userCollection
        .doc(uid)
        .collection("FavouritePlaces")
        .doc(placesId)
        .delete();
  }

  Future deleteRouteData(RouteModel.Route route) {
    return userCollection
        .doc(uid)
        .collection("Routes")
        .doc(route.name)
        .delete();
  }

  Future<bool> checkIfPlaceExists(String placesId) async {
    try {
      // Get reference to Firestore collection
      var doc = await userCollection
          .doc(uid)
          .collection("Places")
          .doc(placesId)
          .get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkIfFavPlaceExists(String placesId) async {
    try {
      // Get reference to Firestore collection
      var doc = await userCollection
          .doc(uid)
          .collection("FavouritePlaces")
          .doc(placesId)
          .get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllRoutesDocs() async {
    try {
      // Get reference to Firestore collection
      var doc = await userCollection.doc(uid).collection("Routes").get();
      return doc;
    } catch (e) {
      throw e;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPlacesDocs() async {
    try {
      // Get reference to Firestore collection
      var doc = await userCollection.doc(uid).collection("Places").get();
      return doc;
    } catch (e) {
      throw e;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllFavPlacesDocs() async {
    try {
      // Get reference to Firestore collection
      var doc =
          await userCollection.doc(uid).collection("FavouritePlaces").get();
      return doc;
    } catch (e) {
      throw e;
    }
  }

  Future<void> savePlaceRoute(Place place, String name) async {
    bool exists = false;
    await userCollection.doc(uid).collection("Routes").doc(name).get().then((value) async {
      List<dynamic> list = value.data()!['places'];
      final places = list.map((e) => Place.fromJson(e)).toList();
      for (Place plc in places) {
        if (plc.placeId == place.placeId) {
          return null;
        }
      }
      var listplace = [place].map((e) => e.toJson()).toList();
      await userCollection
          .doc(uid)
          .collection("Routes")
          .doc(name)
          .update({"places": FieldValue.arrayUnion(listplace)});
    });
  }

  Future updatePlaceData(String Address, String Lat, String Lng, String Name,
      String PlaceId, String Rating, List<String> PhotoReferences) async {
    return await userCollection
        .doc(uid)
        .collection("Places")
        .doc(PlaceId)
        .set({
      'Address': Address,
      "Lat": Lat,
      "Lng": Lng,
      "Name": Name,
      "PlaceID": PlaceId,
      "Rating": Rating,
      "PhotoReferences": PhotoReferences,
      "isVisited": false
    });
  }

  Future updateFavPlaceData(String Address, String Lat, String Lng, String Name,
      String PlaceId, String Rating, List<String> PhotoReferences) async {
    return await userCollection
        .doc(uid)
        .collection("FavouritePlaces")
        .doc(PlaceId)
        .set({
      'Address': Address,
      "Lat": Lat,
      "Lng": Lng,
      "Name": Name,
      "PlaceID": PlaceId,
      "Rating": Rating,
      "PhotoReferences": PhotoReferences,
    });
  }

  Future updateVisitedPlace(String PlaceId) async {
    await userCollection.doc(uid).collection("Places").doc(PlaceId).update({
      'isVisited': true
    });
  }

  Future unMarkVisitedPlace(String PlaceId) async {
    await userCollection.doc(uid).collection("Places").doc(PlaceId).update({
      'isVisited': false
    });
  }

  Future<void> deletePlaceFromRoute(Place place, RouteModel.Route route) async {
    // var val=[];
    // var removedPlace = await PlacesCollection.doc(uid).collection("Routes").doc(route.name).collection("Places").doc(place.placeId).get();
    // val.add(removedPlace);
    var listplace = [place].map((e) => e.toJson()).toList();
    await userCollection
        .doc(uid)
        .collection("Routes")
        .doc(route.name)
        .update({"places": FieldValue.arrayRemove(listplace)});
  }

  Future<bool> checkIfRouteExists(RouteModel.Route route) async {
    try {
      // Get reference to Firestore collection
      var doc = await userCollection
          .doc(uid)
          .collection("Routes")
          .doc(route.name)
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get groups {
    return groupCollection.snapshots();
  }

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid!,
        firstName: snapshot.get('Firstname'),
        groupId: snapshot.get('groupId'),
        lastName: snapshot.get('Surname'),
        isAnon: snapshot.get('isAnon'),
        age: snapshot.get('Age'));
  }

  GroupData _groupDataFromSnapshot(DocumentSnapshot snapshot) {
    return GroupData(
        joinCode: snapshot.get('JoinCode'),
        groupLeader: snapshot.get('leaderUID'),
        groupList: snapshot.get('listOfUsers'),
        groupName: snapshot.get('groupName'),
        journeyStarted: snapshot.get('journeyStarted'));
  }

  //get user doc stream
  Stream<UserData?> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get GroupData stream
  Stream<GroupData?> get groupData {
    return groupCollection.doc(groupId).snapshots().map(_groupDataFromSnapshot);
  }

  void startJourney() async{
    await groupCollection.doc(groupId).update({
      'journeyStarted': true
    });
  }

  void endJourney() async{
    await groupCollection.doc(groupId).update({
      'journeyStarted': false
    });
  }

  Future<bool> getJourneyStarted() async{
    var group =
        await groupCollection.doc(groupId).get();
    return group.get('journeyStarted');
  }

  Future<String> getLeaderUID() async{
    var group =
        await groupCollection.doc(groupId).get();
    return group.get('leaderUID');
  }

  Future<void> disbandGroup(String groupUID) async {
    try {
      final QuerySnapshot searchedJoinCode =
          await userCollection.where("groupId", isEqualTo: groupUID).get();
      dynamic documents = searchedJoinCode.docs;
      for (var doc in documents) {
        final DocumentSnapshot getuserdoc =
            await userCollection.doc(doc.id).get();
        await userCollection.doc(doc.id).update({'groupId': ''});
      }
      await groupCollection.doc(groupUID).delete();
    } catch (e) {
      //print(e);
    }
  }

  Future<void> removeUserFromGroup(String groupUID) async {
    try {
  
      await groupCollection.doc(groupUID).update({
        'listOfUsers': FieldValue.arrayRemove([uid]),
      });
      await userCollection.doc(uid).update({
        'groupId': '' // update foreign key in user model
      });
    } catch (e) {
      //print(e);
    }
  }

  Future<void> addUserToGroup(String joinCode) async {
    try {
      final QuerySnapshot searchedJoinCode = await groupCollection
          .where("JoinCode", isEqualTo: joinCode)
          .limit(1)
          .get();
      // if it is possible that searchedUserId returns no document make sure to
      // check whether searchedUserId.documents.length > 0,
      // otherwise searchedUserId.documents.first will throw an error
      DocumentSnapshot document = searchedJoinCode.docs.first;
      final groupDocID = document.id;
      final DocumentSnapshot getuserdoc =
          await groupCollection.doc(groupDocID).get();

      await groupCollection.doc(groupDocID).update({
        'listOfUsers': FieldValue.arrayUnion([uid]),
      });
      await userCollection.doc(uid).update({
        'groupId': groupDocID,
      });
    } catch (e) {
     // print(e);
    }
    //print('user added to group!');
  }

  Future<void> createGroup(String groupName) async {
    List<String?> members = [];
    members.add(uid);
    try {
      DocumentReference _docref = await groupCollection.add({
        'leaderUID': uid,
        'listOfUsers': members,
        'routeID': '',
        'groupName': groupName,
        'journeyStarted': false,
      });

      await userCollection.doc(uid).update({
        'groupId': _docref.id // update foreign key in user model
      }); // update groupID as the hash of the document ID
      //print("Group Added");

      await groupCollection.doc(_docref.id).update({
        'JoinCode': getHashID(_docref.id)
      }); // add the groupID to the document on firestore

    } catch (e) {
     // print(e);
    }
  }

  Future<void> deleteUser() async {
    String docref = userCollection.doc(uid).id;
    DocumentReference _docref = userCollection.doc(uid);
    FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(_docref);
    });
//       await Firestore.instance.runTransaction((Transaction myTransaction) async {
//     await myTransaction.delete(snapshot.data.documents[index].reference);
// });
  }

  //.then((value) => print("Group Added"))
  //.catchError((error) => print("Failed to add user: $error"));
  Stream<List<Place>> get places {
    return userCollection
        .doc(uid)
        .collection("Places")
        .snapshots()
        .map(_placefromSnapShot);
  }

  Stream<List<Place>> get favouritePlaces {
    return userCollection
        .doc(uid)
        .collection("FavouritePlaces")
        .snapshots()
        .map(_placefromSnapShot);
  }

  List<Place> _placefromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Place(
          address: doc['Address'] ?? "",
          lat: doc["Lat"] ?? "",
          lng: doc["Lng"] ?? "",
          name: doc["Name"] ?? "",
          placeId: doc["PlaceID"] ?? "",
          rating: doc["Rating"] ?? "",
          photoreferences: doc["PhotoReferences"] ?? []);
    }).toList();
  }

  Stream<List<Place>> get attractions {
    return FirebaseFirestore.instance
        .collection("attractions")
        .snapshots()
        .map(_attractionsfromSnapShot);
  }

  List<Place> _attractionsfromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Place(
          address: doc['address'] ?? "",
          lat: doc["latitude"] ?? "",
          lng: doc["longitude"] ?? "",
          name: doc["name"] ?? "",
          placeId: doc["placeId"] ?? "",
          rating: doc["rating"] ?? "",
          photoreferences: doc["photoreferences"] ?? []);
    }).toList();
  }

  List<RouteModel.Route> _routefromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<dynamic> list = doc['places'] ?? [];
      final places = list.map((e) => Place.fromJson(e)).toList();
      return RouteModel.Route(name: doc['name'], places: places);
    }).toList();
  }

  Stream<List<RouteModel.Route>> get routes {
    return userCollection
        .doc(uid)
        .collection("Routes")
        .snapshots()
        .map(_routefromSnapShot);
  }

  Future<DocumentSnapshot<Object?>> getcurrentUser() async {
    return await userCollection.doc(uid).get().then((value) {
      return value;
    });
  }
}
