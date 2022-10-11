import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:tfl_api_client/tfl_api_client.dart' as tflApi;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_hire_app/services/requests/mapbox_walking.dart' as mapbox_walking;
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';



/*
A class containing helper methods for the Map
 */

List<LatLng> sortPoints(List<LatLng> inList, LatLng startLocation){
  List<LatLng> unsortedList = inList;
  List<LatLng> sortedList = [];
  LatLng currentLocation = startLocation;
  LatLng closestLocation = unsortedList[0];

  while(unsortedList.isNotEmpty) {
    for (int i = 0; i < unsortedList.length; i++) {
      if (calculateDistance(currentLocation.latitude, currentLocation.longitude,
          unsortedList[i].latitude, unsortedList[i].longitude)
          < calculateDistance(currentLocation.latitude, currentLocation.longitude,
              closestLocation.latitude, closestLocation.longitude)) {
        closestLocation = unsortedList[i];
      }
    }
    unsortedList.remove(closestLocation);
    sortedList.add(closestLocation);
    currentLocation = closestLocation;
    if(unsortedList.isNotEmpty) {
      closestLocation = unsortedList[0];
    }
  }

  return sortedList;
}

double getPolylineLength(List<LatLng> polyCoords){
  double length = 0;
  if(polyCoords.length>1) {
    for (int i = 0; i < polyCoords.length - 1; i++) {
      var nextElem = polyCoords[i + 1];
      length += calculateDistance(polyCoords[i].latitude,
          polyCoords[i].longitude, nextElem.latitude,
          nextElem.longitude);
    }
  }
  return length;
}

double getPolylineLengthFromPoint(LatLng inLatLng, List<LatLng> polyCoords){
  var temp = polyCoords.indexOf(inLatLng);
  double length = 0;
  if(polyCoords.length>1) {
    for (int i = temp; i < polyCoords.length - 1; i++) {
      var nextElem = polyCoords[i + 1];
      length += calculateDistance(polyCoords[i].latitude,
          polyCoords[i].longitude, nextElem.latitude,
          nextElem.longitude);
    }
  }
  return length;
}


LatLng findClosestPointInList(LatLng inLatLng, List<LatLng> inList){
  var closestPoint = inList[0];
  for(int i = 0; i<inList.length; i++){
    if(calculateDistance(inLatLng.latitude, inLatLng.longitude,
        inList[i].latitude, inList[i].longitude) <
        calculateDistance(closestPoint.latitude, closestPoint.longitude,
            inLatLng.latitude, inLatLng.longitude)
    ){
      closestPoint = inList[i];
    }
  }
  return closestPoint;
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double calculateDistanceUsingLatLng(LatLng LL1, LatLng LL2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((LL2.latitude - LL1.latitude) * p) / 2 +
      cos(LL1.latitude * p) * cos(LL2.latitude * p) * (1 - cos((LL2.longitude - LL1.longitude) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Future<tflApi.Place> findClosestBikePoint(LatLng inLatLng, int minBikes, int minSpaces) async {
  final client = tflApi.clientViaAppKey("1fcc37f1164744cebb060c7b3b5d8486");

  final api = tflApi.TflApiClient(client: client);
  final response = await api.bikePoints.getAll();

  List<tflApi.Place> tempBikeList = <tflApi.Place>[];

  for (var element in response) {
    try {
      int NbDocks = int.parse(element.additionalProperties![8].value!);
      int NbEmptyDocks = int.parse(element.additionalProperties![7].value!);
      int NbBikes = int.parse(element.additionalProperties![6].value!);

      // filter out broken docks
      if((NbDocks) - (NbBikes + NbEmptyDocks) == 0){
        if(NbEmptyDocks >= minSpaces && NbBikes >= minBikes) {
          tempBikeList.add(element);
        }
      }
    } catch(e){

    }
    
  }

  tflApi.Place closestBikePoint = tempBikeList[0];
  for (var t in tempBikeList) {
    if (calculateDistance(
        t.lat, t.lon, inLatLng.latitude, inLatLng.longitude) <
        calculateDistance(closestBikePoint.lat, closestBikePoint.lon,
            inLatLng.latitude, inLatLng.longitude)) {
      closestBikePoint = t;
    }
  }
  return closestBikePoint;
}

showActivityListDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cannot start journey"),
    content: Text("Add another route to your itinerary"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showCustomTextDialog(BuildContext context, String text, String label) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(label),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}