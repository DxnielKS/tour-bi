import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bicycle_hire_app/services/map_helpers/map_helpers.dart' as map_helpers;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tfl_api_client/tfl_api_client.dart';
import 'test_data.dart' as test_data;


  void main() {

    test('Load bikepoint file', () async {
      final file = File('test/screens/map/journey/bikepoint.json');
      final json = jsonDecode(await file.readAsString());
      //TODO
    });

    test('Sort points works correctly' , (){
      LatLng London = LatLng(51.52085816222102, -0.131042727582235924);
      List<LatLng> randomPoints = [
        London, // London
        LatLng(40.67021127584097, -74.00576435359152), // New York
        LatLng(55.95245065601637, -3.218858850164437), // Edinburgh
        LatLng(40.47062411937024, -3.7792964421815345), // Madrid
        LatLng(52.48678730936306, -2.003197724300686), // Birmingham
      ];
      List<LatLng> sortedPoints = [
        London, // London
      LatLng(52.48678730936306, -2.003197724300686), // Birmingham
      LatLng(55.95245065601637, -3.218858850164437), // Edinburgh
      LatLng(40.47062411937024, -3.7792964421815345), // Madrid
      LatLng(40.67021127584097, -74.00576435359152) // New York
      ];
      var res = map_helpers.sortPoints(randomPoints, London); // Sort these points relative to london
      expect(sortedPoints, res);
    });

    test('Get polyline length works', () {
      // Calculates the distance between each point in a LatLng list
      var tempCoords = test_data.tempPolylinePoints;
      var testResponse = map_helpers.getPolylineLength(tempCoords)*1000; // convert km to m
      // The length of these coordinates are given on the request
      // https://api.mapbox.com/directions/v5/mapbox/cycling/-0.08898121491386994,51.525432558001484;-0.1055355860286759,51.52228402259405/?alternatives=false&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoiZGF3dWRvc21hbiIsImEiOiJjbDEwdnFvaWYyaDAyM2Nqd3J4OXZscG1pIn0.NvqZOkwZlNkDOpNzk6OSew
      double expected = 1501.5;
      double diff = (expected - testResponse).abs();

      // Given a tolerance of 5 percent
      var tolerance = testResponse*0.05;
      expect(diff, lessThanOrEqualTo(tolerance));
    });

    test('Get polyline length returns 0 for an empty list', (){
      List<LatLng> tempCoords = [];
      var testResponse = map_helpers.getPolylineLength(tempCoords)*1000; // convert km to m
      expect(testResponse, 0);
    });


    test('Get polyline length from point works', (){
      var tempCoords = [LatLng(50,60), LatLng(55, 65), LatLng(60, 70)]
          + test_data.tempPolylinePoints; // the test data with random coordinates in front
      var testResponse = map_helpers.getPolylineLengthFromPoint(tempCoords[3], tempCoords);
      var expected = map_helpers.getPolylineLength(test_data.tempPolylinePoints);

      expect(expected, testResponse);
    });

    test('Get polyline length from last point returns 0', (){
      var tempCoords = test_data.tempPolylinePoints;
      var testResponse = map_helpers.getPolylineLengthFromPoint(tempCoords.last, tempCoords);
      expect(testResponse, 0);
    });

    test('Get polyline length from point returns 0 for an empty list', (){
      List<LatLng> tempCoords = [];
      var testResponse = map_helpers.getPolylineLengthFromPoint(LatLng(51.52085816222102, -0.131042727582235924),
          tempCoords)*1000; // convert km to m
      expect(testResponse, 0);
    });

    test ('Find closest point in list works', (){
      LatLng London = LatLng(51.52085816222102, -0.131042727582235924);
      List<LatLng> randomPoints = [
        London, // London
        LatLng(40.67021127584097, -74.00576435359152), // New York
        LatLng(55.95245065601637, -3.218858850164437), // Edinburgh
        LatLng(40.47062411937024, -3.7792964421815345), // Madrid
        LatLng(52.48678730936306, -2.003197724300686), // Birmingham
      ];
      LatLng currentPosition = LatLng(51.51199199782566, -0.11706977666360266); // KCL

      var tempResponse = map_helpers.findClosestPointInList(currentPosition, randomPoints);
      expect(tempResponse, London);

    });

    test ('Find closest bike point works correctly', () async {
      LatLng currentLocation = LatLng(51.499606, -0.197574); // The exact LatLng of bike point with id "BikePoints_2"
      var closestBikePoint = await map_helpers.findClosestBikePoint(
          currentLocation, 0, 0); // Find the closest bike point to me (with no restrictions on it's capacity
      final file = File('test/screens/map/journey/bikepoint.json');
      final json = jsonDecode(await file.readAsString());
      var bpName = json[1]["commonName"];
      double bpLat = json[1]["lat"];
      double bpLon = json[1]["lon"];
      String bpID = json[1]["id"];

      expect(closestBikePoint.commonName!, bpName);
      expect(closestBikePoint.lat!, bpLat);
      expect(closestBikePoint.lon!, bpLon);
      expect(closestBikePoint.id!, bpID);
    });

    test ('Calculate distance works correctly', (){
      double lat1 = 52.2296756;
      double lon1 = 21.012287;
      double lat2 = 52.406374; // Sample pointw taken from the web
      double lon2 = 16.9251681;
      var res = map_helpers.calculateDistance(
          lat1, lon1, lat2, lon2
      );

      expect(res, 278.4621263247644);

    });

    test ('Calculate distance using LatLng works correctly', (){
      var LatLng1 = LatLng(52.2296756, 21.012287);
      var LatLng2 = LatLng(52.406374, 16.9251681);
      var res = map_helpers.calculateDistanceUsingLatLng(LatLng1, LatLng2);
      expect(res, 278.4621263247644);
    });



  }

  