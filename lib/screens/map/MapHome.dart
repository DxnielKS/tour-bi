import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:typed_data';
import 'dart:async';
import 'package:bicycle_hire_app/constants/customWidgets/OurToggle.dart';
import 'package:bicycle_hire_app/constants/customWidgets/our_text.dart';
import 'package:bicycle_hire_app/constants/loading/loading.dart';
import 'package:bicycle_hire_app/screens/activity_list/activities_provider.dart';
import 'package:bicycle_hire_app/screens/favourites/favourites_grid.dart';
import 'package:bicycle_hire_app/screens/favourites/route_save.dart';
import 'package:bicycle_hire_app/screens/sidebar/provider_drawer.dart';
import 'package:bicycle_hire_app/screens/turnByTurn/mapbox_turn_by_turn.dart';
import 'package:flutter/services.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:bicycle_hire_app/services/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as polyline;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import "package:location/location.dart" as loc;
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../../models/Place.dart';
import '../../models/map_style.dart';
import '../../services/authHelpers/auth_service.dart';
import '../../services/requests/database_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl_api_client/tfl_api_client.dart' as tflApi;
import "package:bicycle_hire_app/services/requests/mapbox_cycling.dart"
    as mapbox_cycling;
import "package:bicycle_hire_app/services/requests/mapbox_walking.dart"
    as mapbox_walking;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_dialogs/material_dialogs.dart' as material_dialog;
import 'package:bicycle_hire_app/services/map_helpers/map_helpers.dart'
    as map_helpers;
import 'package:intl/intl.dart';

class MapHome extends StatefulWidget {
  const MapHome({Key? key}) : super(key: key);

  @override
  _MapHomeState createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  final AuthService _auth = AuthService();

  int selectedPage = 0;
  int currentIndex = 0;
  bool isSearch = false;
  bool isChangeMap = false;
  int NO_OF_PEOPLE = 0;
  bool routeLoading = false;
  bool followUserOnMap = false;
  bool userOnFoot = false;
  bool userOnBike = false;

  bool ORDER_ROUTES = false;

  bool JOURNEY_STARTED = false;

  bool buttonDelay = false;

  // the bike point from which the journey will begin... updated periodically so could change
  tflApi.Place? startBikePoint;
  tflApi.Place? endBikePoint;

  late TextEditingController textController;

  late TextEditingController noOfBikesController;
  late TextEditingController noOfEmptySpacesController;

  String googleApikey = "AIzaSyCKOGbabmrKS5ty3mnW0hT88jQj8KG-aOE";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng startMap = LatLng(51.509865, -0.118092);

  Set<Marker> markers = Set<Marker>();

  polyline.PolylinePoints polylinePoints = polyline.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  StreamSubscription? _locationSubscription;
  loc.Location _locationTracker = loc.Location();
  Marker? currentLocationMarker;
  Circle? circle;

  bool TRACK_USER_WALKING = false;

  bool TRACK_USER_ON_BIKE = false;

  bool TRACK_USER_LAST_LEG = false;

  late BitmapDescriptor bikeMarker;
  late BitmapDescriptor placeMarker;

  List<LatLng> polylineCoordinates = [];
  List<LatLng> tempWalkingCoords = [];

  void updateStartBikePoint() async {
    while (searchForNewStartBP) {
      await Future.delayed(const Duration(seconds: 15));
      print("SEARCHING FOR NEW START BIKE POINT");
      try {
        print("TIMER IS RUNNING");
        LatLng currentLoc = await getCurrentLocationAsLatLng();
        var tempValue =
            await map_helpers.findClosestBikePoint(currentLoc, NO_OF_PEOPLE, 0);
        if (placeToLatLng(tempValue) != placeToLatLng(startBikePoint!)) {
          setState(() {
            print("ABOUT TO SET START BP TO FALSE");
            searchForNewStartBP = false;
            print("REACHED PAST START BP =FALSE YESSS");
            TRACK_USER_WALKING = false;
            clearMarkers();
            polylineCoordinates.clear();
            polylines.clear();
          });
          map_helpers.showCustomTextDialog(
              context, "Notice", "Your route has changed");
          getBikeDirectionsByFoot();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void updateEndBikePoint() async {
    while (searchForNewEndBP) {
      await Future.delayed(Duration(seconds: 15));
      print("SEARCHING FOR NEW END BIKE POINT");
      try {
        LatLng currentLoc = await getCurrentLocationAsLatLng();
        var tempValue =
            await map_helpers.findClosestBikePoint(currentLoc, 0, NO_OF_PEOPLE);
        if (placeToLatLng(tempValue) != placeToLatLng(endBikePoint!)) {
          setState(() {
            TRACK_USER_ON_BIKE = false;
            searchForNewEndBP = false;
            clearMarkers();
            polylineCoordinates.clear();
            polylines.clear();
          });
          map_helpers.showCustomTextDialog(
              context, "Notice", "Your route has changed");
          getEndBikeDirections();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/mapIcons/bike_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      loc.LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      currentLocationMarker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        print("\n\n\nLOCATION CHANGED\n\n\n");
        if (mapController != null && followUserOnMap) {
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 192.8334901395799,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 0,
                  zoom: 18.00)));
        }
        if (mapController != null) {
          updateMarkerAndCircle(newLocalData, imageData);
        }

        if (TRACK_USER_WALKING) {
          print("WALKING SUBSCRIPTION IS ACTIVE");
          LatLng updatedLoc =
              LatLng(newLocalData.latitude!, newLocalData.longitude!);
          var closestPolylinePoint =
              map_helpers.findClosestPointInList(updatedLoc, tempWalkingCoords);

          var tempDistance = map_helpers.calculateDistance(
                  newLocalData.latitude,
                  newLocalData.longitude,
                  startBikePoint?.lat,
                  startBikePoint?.lon) *
              (1000);
          if (tempDistance <= 20 && userOnFoot && !userOnBike) {
            setState(() {
              TRACK_USER_WALKING = false;
              searchForNewStartBP = false;
              userOnFoot = false;
              userOnBike = true;
              polylines.clear();
              clearMarkers();
              startBikeJourney();
            });
            showBikeConfirmationDialog(context);
          }
        }

        if (TRACK_USER_ON_BIKE) {
          print("CYCLING SUBSCRIPTION IS ACTIVE");
          //
          LatLng updatedLoc =
              LatLng(newLocalData.latitude!, newLocalData.longitude!);

          List<LatLng> pointsToRemove = [];
          for (var w in wayPoints) {
            var closestPolylineWP =
                map_helpers.findClosestPointInList(w, polylineCoordinates);
            if (map_helpers.calculateDistanceUsingLatLng(
                    map_helpers.findClosestPointInList(
                        updatedLoc, polylineCoordinates),
                    closestPolylineWP) <=
                0.1) {
              pointsToRemove.add(w);
              markPlaceAsVisited(w);
            }
          }
          for (var p in pointsToRemove) {
            wayPoints.remove(p);
            markers.removeWhere((element) => element.position == p);
            polylineCoordinates.removeWhere((element) =>
                polylineCoordinates.indexOf(map_helpers.findClosestPointInList(
                    p, polylineCoordinates)) >
                polylineCoordinates.indexOf(element));
          }

          if (pointsToRemove.isNotEmpty) {
            polylines.clear();
            addPolyLine(polylineCoordinates);
            pointsToRemove.clear();
          }

          if (wayPoints.isEmpty) {
            print("\n\n\nYOU HAVE VISITED EVERY PLACE\n\n\n");
            map_helpers.showCustomTextDialog(
                context, "you have visited every place", "Notice");
            getEndBikeDirections();
            setState(() => TRACK_USER_ON_BIKE = false);
          }
        }

        if (TRACK_USER_LAST_LEG) {
          print("CYCLING SUBSCRIPTION FOR END BIKE POINT  IS ACTIVE");
          LatLng updatedLoc =
              LatLng(newLocalData.latitude!, newLocalData.longitude!);
          var closestPolylinePoint = map_helpers.findClosestPointInList(
              updatedLoc, polylineCoordinates);

          var tempDistance = map_helpers.calculateDistance(
                  newLocalData.latitude,
                  newLocalData.longitude,
                  endBikePoint?.lat,
                  endBikePoint?.lon) *
              (1000);
          if (tempDistance <= 20) {
            map_helpers.showCustomTextDialog(
                context, "you have finished your journey", "Notice");
            cancelJourney();
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  bool showAttractions = true;

  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 60;
  double CAMERA_BEARING = 30;

  LatLng searchLocation = LatLng(0, 0);

  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  List<LatLng> wayPoints = [];

  bool searchForNewEndBP = false;
  bool searchForNewStartBP = false;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _secondBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _thirdBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _fourthBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _fifthBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _sixthBtnController =
      RoundedLoadingButtonController();

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId(polylineCoordinates.toString());
    Polyline polyline = Polyline(
      polylineId: id,
      color: globals.polylineColours[mapIndex],
      points: polylineCoordinates,
      width: 10,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  LatLng placeToLatLng(tflApi.Place inPlace) {
    return LatLng(inPlace.lat!, inPlace.lon!);
  }

  Future<void> getPolyline(
      List<LatLng> inList, Map<LatLng, String> names) async {
    LatLng currentPos = await getCurrentLocationAsLatLng();
    int index = 0;

    List<LatLng> POIs =
        ORDER_ROUTES ? map_helpers.sortPoints(inList, currentPos) : inList;

    LatLng startLocation;

    if (startBikePoint == null) {
      startLocation = await getCurrentLocationAsLatLng();
    } else {
      startLocation = placeToLatLng(startBikePoint!);
    }
    List<LatLng> requestWaypoints = [startLocation] + POIs;
    wayPoints = POIs;
    try {
      List<LatLng> tempCoords =
          await mapbox_cycling.getCyclingRouteUsingList(requestWaypoints);
      // tempCoords.forEach((element) {print(element);});
      addPolyLine(tempCoords);
      polylineCoordinates = tempCoords;
    } catch (e) {
      debugPrint(e.toString());
    }
    for (var element in POIs) {
      index++;
      addMarker(element.toString(), element, "$index", names[element]!);
    }
  }

  addBikeMarker(String id, LatLng pos, String details, String title) {
    markers.add(Marker(
        markerId: MarkerId(id),
        position: pos,
        icon: bikeMarker,
        infoWindow: InfoWindow(title: title, snippet: details)));
    setState(() {});
  }

  addMarker(String id, LatLng pos, String details, String title) {
    markers.add(Marker(
        markerId: MarkerId(id),
        position: pos,
        icon: placeMarker,
        infoWindow: InfoWindow(title: title, snippet: details)));
    setState(() {});
  }

  void clearMarkers() {
    //Clear every marker but the bike marker
    setState(() {
      markers.removeWhere((element) => element != currentLocationMarker);
    });
  }

  late int mapIndex;

  void changeMap() {
    showModalBottomSheet(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Theme",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: globals.mapThemes.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  var data = await DatabaseService(
                                    uid: _auth.getCurrent()?.uid,
                                  );
                                  data.updateUserThemeData(index);
                                  setState(() {
                                    mapIndex = index;
                                  });
                                  startJourney();
                                  mapController?.setMapStyle(
                                      globals.mapThemes[index]['style']);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            globals.mapThemes[index]['image']),
                                      )),
                                ),
                              );
                            }),
                      ),
                    ],
                  )),
            ));
  }

  void _showInfoPanel(
      var images,
      GoogleMapsPlaces place,
      String name,
      String formattedAddress,
      String rating,
      String placeId,
      List<dynamic> photos,
      String lat,
      String lng) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 250,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                place.buildPhotoUrl(
                                    photoReference: images[index],
                                    maxHeight: 500,
                                    maxWidth: 500),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Expanded(
                    child: Card(
                      color: globals.themeColours[mapIndex],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                              "Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: globals.textColours[mapIndex],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber.shade300,
                                child: Icon(Icons.map_outlined),
                              ),
                              title: Text(
                                'Name: ${name}',
                                style: TextStyle(
                                    color: globals.textColours[mapIndex]),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber.shade300,
                                child: Icon(Icons.location_on),
                              ),
                              title: Text('Address: ${formattedAddress}',
                                  style: TextStyle(
                                      color: globals.textColours[mapIndex])),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber.shade300,
                                child: Icon(Icons.rate_review),
                              ),
                              title: Text(
                                'Rating: ${rating}',
                                style: TextStyle(
                                    color: globals.textColours[mapIndex]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //first controller
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: RoundedLoadingButton(
                            width: 130,
                            color: globals.themeColours[mapIndex],
                            successColor: Colors.green,
                            child: Text('Add to route',
                                style: TextStyle(
                                    color: globals.textColours[mapIndex])),
                            controller: _btnController,
                            onPressed: () async {
                              var data = await DatabaseService(
                                  uid: _auth.getCurrent()?.uid);
                              data
                                  .checkIfPlaceExists(placeId)
                                  .then((value) async {
                                if (!value) {
                                  List<String> photoref = [];
                                  for (var photo in images) {
                                    photoref.add(photo);
                                  }
                                  data.updatePlaceData(formattedAddress, lat,
                                      lng, name, placeId, rating, photoref);
                                  _btnController.success();
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            },
                          ),
                        ),
                        RoundedLoadingButton(
                          width: 130,
                          color: globals.themeColours[mapIndex],
                          successColor: Colors.green,
                          child: Text('Add to favourite places',
                              style: TextStyle(
                                  color: globals.textColours[mapIndex])),
                          controller: _secondBtnController,
                          onPressed: () async {
                            var data = await DatabaseService(
                              uid: _auth.getCurrent()?.uid,
                            );
                            data
                                .checkIfFavPlaceExists(placeId)
                                .then((value) async {
                              if (!value) {
                                List<String> photoref = [];
                                for (var photo in images) {
                                  photoref.add(photo);
                                }
                                data.updateFavPlaceData(formattedAddress, lat,
                                    lng, name, placeId, rating, photoref);
                                _secondBtnController.success();
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            });
                          },
                        ),
                      ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Container(
                    child: Center(
                      child: RoundedLoadingButton(
                        width: 170,
                        color: globals.themeColours[mapIndex],
                        successColor: Colors.green,
                        child: Text('Add to favourite routes',
                            style: TextStyle(
                                color: globals.textColours[mapIndex])),
                        controller: _thirdBtnController,
                        onPressed: () async {
                          var data = await DatabaseService(
                              uid: _auth.getCurrent()?.uid);
                          List<String> photoref = [];
                          for (var photo in images) {
                            photoref.add(photo);
                          }
                          Place place = Place(
                              placeId: placeId,
                              lng: lng,
                              lat: lat,
                              rating: rating,
                              name: name,
                              address: formattedAddress,
                              photoreferences: photoref);
                          data.getAllRoutesDocs().then((value) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => (Container(
                                        child: Column(children: [
                                      Expanded(
                                          child: ListView.builder(
                                              itemCount: value.docs.length,
                                              itemBuilder: (context, index) {
                                                return RouteSave(
                                                  route: value.docs[index].id,
                                                  place: place,
                                                );
                                              }))
                                    ]))));
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            _thirdBtnController.reset();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                ]))));
  }

  bool inLondon(PlacesDetailsResponse place) {
    bool inLondon = false;
    place.result.addressComponents.forEach((element) {
      if (element.longName == "London") {
        inLondon = true;
      }
    });
    return inLondon;
  }

  Future<void> SearchBar() async {
    var place = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleApikey,
        insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
        overlayBorderRadius: BorderRadius.circular(30),
        mode: Mode.overlay,
        types: [],
        logo:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            color: Colors.white,
            height: 20,
          )
        ]),
        strictbounds: false,
        location: Location(lat: 51.5072, lng: -0.118092),
        components: [Component(Component.country, 'uk')],
        //google_map_webservice package
        onError: (err) {});

    if (place != null) {
      // setState(() {
      //   destination = place.description.toString();
      // });

      //form google_maps_webservice package
      final plist = GoogleMapsPlaces(
        apiKey: googleApikey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
        //from google_api_headers package
      );
      String placeid = place.placeId ?? "0";
      final detail = await plist.getDetailsByPlaceId(placeid);
      detail.result.addressComponents.forEach((element) {
        //print(element.longName);
      });

      final geometry = detail.result.geometry!;
      List<String> photos = [];
      detail.result.photos.forEach((element) {
        photos.add(element.photoReference);
      });
      var images = photos;
      final lat = geometry.location.lat;
      final lang = geometry.location.lng;
      var newlatlang = LatLng(lat, lang);
      try {
        Marker marker = markers.firstWhere(
            (marker) => marker.markerId.value == searchLocation.toString());
        setState(() {
          markers.remove(marker);
        });
      } catch (e) {}
      if (inLondon(detail)) {
        searchLocation = newlatlang;

        markers.add(Marker(
            markerId: MarkerId(searchLocation.toString()),
            position: searchLocation,
            onTap: () {
              var lat = detail.result.geometry?.location.lat.toString();
              var lng = detail.result.geometry?.location.lng.toString();
              _showInfoPanel(
                  images,
                  plist,
                  detail.result.name,
                  detail.result.formattedAddress!,
                  detail.result.rating.toString(),
                  detail.result.placeId,
                  detail.result.photos,
                  lat!,
                  lng!);
            },
            infoWindow:
                InfoWindow(title: detail.result.name, snippet: 'Location')));

        //move map camera to selected place with animation
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: newlatlang,
                zoom: CAMERA_ZOOM,
                tilt: CAMERA_TILT,
                bearing: CAMERA_BEARING)));
      } else {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Location Invalid'),
            content: Text('Please search a location that is in london'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      setState(() {});
    }
  }

  static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = (await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width)) as ui.Codec;

    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    noOfBikesController = TextEditingController();
    noOfEmptySpacesController = TextEditingController();
    getBytesFromAsset('assets/images/mapIcons/bikeMarker.png', 150)
        .then((onValue) {
      bikeMarker = BitmapDescriptor.fromBytes(onValue!);
    });
    getBytesFromAsset('assets/images/mapIcons/places.png', 100).then((onValue) {
      placeMarker = BitmapDescriptor.fromBytes(onValue!);
    });
    _locationTracker.changeSettings(distanceFilter: 3, interval: 2000);
    getCurrentLocation();
  }

  void cancelJourney() async {
    setState(() {
      JOURNEY_STARTED = false;
      NO_OF_PEOPLE = 0;
      userOnFoot = false;
      userOnBike = false;

      searchForNewStartBP = false;
      startBikePoint = null;

      searchForNewEndBP = false;
      endBikePoint = null;

      polylineCoordinates.clear();
      clearMarkers();
      polylines.clear();
      wayPoints.clear();
      tempWalkingCoords.clear();

      TRACK_USER_ON_BIKE = false;
      TRACK_USER_WALKING = false;
      TRACK_USER_LAST_LEG = false;

      markRouteListAsUnvisited();
    });
    String? groupId = await _auth.getCurrentUserGroupId();
    if (groupId != "") {
      DatabaseService(uid: _auth.getCurrent()?.uid, groupId: groupId)
          .endJourney();
    }
  }

  void markRouteListAsUnvisited() async {
    List<String> placesToUnVisit = [];
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);
    var temp = await data.getAllPlacesDocs();
    for (var t in temp.docs) {
      placesToUnVisit.add(t["PlaceID"]);
    }
    for (var p in placesToUnVisit) {
      data.unMarkVisitedPlace(p);
    }
  }

  void findNearestBikePoint(int noOfBikes, int noEmptySpaces) async {
    clearMarkers();
    var currLoc = await getCurrentLocationAsLatLng();
    var temp = await map_helpers.findClosestBikePoint(
        currLoc, noOfBikes, noEmptySpaces);
    var tempConverted = placeToLatLng(temp);
    var now = DateTime.now();
    var time = DateFormat("h:mma").format(now);
    //print("Location: ${tempConverted}");
    addBikeMarker(
        tempConverted.toString(), tempConverted, "Bikes: ${temp.additionalProperties![6].value!}"
        ", Spaces: ${temp.additionalProperties![7].value!} (Updated $time)", temp.commonName!);
  }

  Widget initMapState() {
    final TextStyle headline4 = Theme.of(context).textTheme.titleLarge!;
    //checkPlaces();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: globals.textColours[mapIndex]),
        title: OurText(
          text: "Explore",
          fontSize: 24,
          underlined: false, color: globals.textColours[mapIndex],
        ),
        elevation: 0.0,
        backgroundColor: globals.themeColours[mapIndex],
        actions: [
          Toggle(),
          SpeedDial(
            backgroundColor: globals.themeColours[mapIndex],
            activeBackgroundColor: Colors.transparent,
            overlayColor: Colors.transparent,
            elevation: 0.0,
            direction: SpeedDialDirection.down,
            animatedIcon: AnimatedIcons.view_list,
            children: [
              SpeedDialChild(
                  visible: JOURNEY_STARTED,
                  child: Icon(Icons.cancel),
                  label: 'Cancel journey',
                  backgroundColor: Colors.red,
                  onTap: () {
                    showCancelConfirmationDialog(context);
                  }),
              SpeedDialChild(
                  backgroundColor: globals.themeColours[mapIndex],
                  visible: !JOURNEY_STARTED,
                  child: Icon(
                    Icons.directions_bike,
                    color: globals.textColours[mapIndex],
                  ),
                  label: 'Find nearest \nbike point',
                  onTap: () {
                    showBikePointConfigurationDialog();
                  }),
              SpeedDialChild(
                  backgroundColor: globals.themeColours[mapIndex],
                  visible: !JOURNEY_STARTED,
                  child: Icon(
                    Icons.cached,
                    color: globals.textColours[mapIndex],
                  ),
                  label: 'Clear markers',
                  onTap: () {
                    clearMarkers();
                  }),
              SpeedDialChild(
                  visible: wayPoints.isNotEmpty,
                  child: Icon(Icons.add, color: globals.textColours[mapIndex]),
                  label: 'Show turn by turn view',
                  backgroundColor: globals.themeColours[mapIndex],
                  // backgroundColor: Colors.blue,
                  onTap: () async {
                    var tempCurrentLoc = await getCurrentLocationAsLatLng();
                    //TODO: Mark activities in activity list as not visited?
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapBox(
                                routeWaypoints: [tempCurrentLoc] + wayPoints,
                              )),
                    );
                  }),
              SpeedDialChild(
                backgroundColor: globals.themeColours[mapIndex],
                onTap: () {
                  changeMap();
                },
                child: Icon(Icons.color_lens,
                    color: globals.textColours[mapIndex]),
                label: 'Change theme',
              ),
              SpeedDialChild(
                  backgroundColor: globals.themeColours[mapIndex],
                  onTap: () async {
                    setState(() => followUserOnMap = !followUserOnMap);
                    if (followUserOnMap) {
                      LatLng currentPos = await getCurrentLocationAsLatLng();
                      mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              bearing: 192.8334901395799,
                              target: LatLng(
                                  currentPos.latitude, currentPos.longitude),
                              tilt: 0,
                              zoom: 18.00)));
                    }
                  },
                  child: Icon(
                    Icons.my_location,
                    color: globals.textColours[mapIndex],
                  ),
                  label: followUserOnMap ? 'Tracking is\ncurrently on' :
                  'Tracking is\ncurrently off'),

              SpeedDialChild(
                  backgroundColor: globals.themeColours[mapIndex],
                  onTap: () async {
                    var data =
                        await DatabaseService(uid: _auth.getCurrent()?.uid);
                    var temp = await data.getAllPlacesDocs();
                    String routeInfo = "";
                    for (var t in temp.docs) {
                      if (t["isVisited"]) {
                        routeInfo += t["Name"] + " : \u2714";
                      } else {
                        routeInfo += t["Name"] + " : \u274c";
                      }
                      routeInfo += "\n";
                    }
                    map_helpers.showCustomTextDialog(
                        context, routeInfo, "Visited places:");
                  },
                  child: Icon(
                    Icons.info,
                    color: globals.textColours[mapIndex],
                  ),
                  label: "View visited \nplaces"),
              SpeedDialChild(
                  visible: !JOURNEY_STARTED,
                  backgroundColor: globals.themeColours[mapIndex],
                  onTap: () {
                    setState(() => ORDER_ROUTES = !ORDER_ROUTES);
                  },
                  child: Icon(
                    Icons.sort,
                    color: globals.textColours[mapIndex],
                  ),
                  label: ORDER_ROUTES
                      ? "Routes currently\nset to ordered"
                      : "Routes currently\nset to unordered")
            ],
          ),
        ],
      ),
      drawer: DrawerProvider(),
      body: Stack(children: [
        GoogleMap(
          buildingsEnabled: false,
          //Map widget from google_maps_flutter package
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          //enable Zoom in, out on map
          initialCameraPosition: CameraPosition(
            //innital position in map
            target: startMap, //initial position
            zoom: 10,
            // tilt: CAMERA_TILT,
            // bearing: CAMERA_BEARING //initial zoom level
          ),
          mapType: MapType.normal,
          markers: Set.of((currentLocationMarker != null)
              ? [currentLocationMarker!] + markers.toList()
              : markers.toList()),
          circles: Set.of((circle != null) ? [circle!] : []),
          polylines: Set<Polyline>.of(polylines.values),
          // myLocationEnabled: true,
          // myLocationButtonEnabled: true,
          //map type
          onMapCreated: (controller) {
            //method called when map is created
            if (mounted) {
              setState(() {
                mapController = controller;
                mapController
                    ?.setMapStyle(globals.mapThemes[mapIndex]['style']);
                //mapController?.setMapStyle(_mapThemes[mapIndex]['style']);
              });
            }
          },
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.5,
            ),
            ValueListenableBuilder(
                valueListenable: globals.show_attractions,
                builder: (BuildContext context, bool value, Widget? child) {
                  return value
                      ? Text(
                          "London Attractions",
                          style: GoogleFonts.heebo(
                              textStyle: headline4,
                              fontWeight: FontWeight.w600,
                              color: globals.titleColours[mapIndex],
                              letterSpacing: 1.3),
                        )
                      : Container();
                })
          ],
        ),
        _buildContainer(),
      ]),
    );
  }

  final iconList = <IconData>[
    Icons.map_rounded,
    Icons.favorite_outlined,
    Icons.search,
    Icons.location_city_rounded,
  ];
  var _selectedTab = _SelectedTab.home;

  Future<GoogleMapsPlaces> getPlist() async {
    final plist = GoogleMapsPlaces(
      apiKey: googleApikey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    return plist;
  }

  Widget _buildContainer() {
    var data = DatabaseService(uid: _auth.getCurrent()?.uid);

    return ValueListenableBuilder(
        valueListenable: globals.show_attractions,
        builder: (BuildContext context, bool value, Widget? child) {
          return value
              ? StreamBuilder<List<Place>>(
                  stream: data.attractions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 130.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _boxes(snapshot.data![index]),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                )
              : Container();
        });
  }

  late GoogleMapsPlaces apiPlace;

  Widget _boxes(Place place) {
    return FutureBuilder(
        future: getPlist(),
        builder:
            (BuildContext context, AsyncSnapshot<GoogleMapsPlaces> snapshot) {
          if (snapshot.hasData) {
            apiPlace = snapshot.data!;
            return GestureDetector(
              onTap: () {
                _showInfoPanel(
                    place.photoreferences,
                    apiPlace,
                    place.name,
                    place.address,
                    place.rating,
                    place.placeId,
                    place.photoreferences,
                    place.lat,
                    place.lng);
              },
              child: Container(
                child: FittedBox(
                  child: Material(
                      color: globals.themeColours[mapIndex],
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                      shadowColor: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 270,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(24.0),
                              child: Image.network(
                                apiPlace.buildPhotoUrl(
                                    photoReference: place.photoreferences[0],
                                    maxHeight: 500,
                                    maxWidth: 500),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: myDetailsContainer1(place),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Widget myDetailsContainer1(Place place) {
    final TextStyle headline4 = Theme.of(context).textTheme.titleLarge!;
    final TextStyle subtitle = Theme.of(context).textTheme.bodyMedium!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            place.name,
            style: GoogleFonts.nunito(
                textStyle: headline4,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: globals.textColours[mapIndex],
                letterSpacing: 0.9),
          )),
        ),
        SizedBox(height: 5.0),
        Text(
          place.address,
          style: GoogleFonts.poppins(
              textStyle: subtitle,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: globals.textColours[mapIndex],
              letterSpacing: 0.9),
        ),
        SizedBox(height: 5.0),
        Text(
          place.rating + " Rating",
          style: GoogleFonts.poppins(
              textStyle: subtitle,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: globals.textColours[mapIndex],
              letterSpacing: 0.9),
        ),
      ],
    );
  }

  Future<int> getVisitedActivityListSize() async {
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);
    int tempSize = 0;
    var temp = await data.getAllPlacesDocs();
    for (var t in temp.docs) {
      if (t["isVisited"]) {
        tempSize++;
      }
    }
    return tempSize;
  }

  Future<int> getAcitivityListSize() async {
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);
    var temp = await data.getAllPlacesDocs();
    return temp.size;
  }

  Future<LatLng> getCurrentLocationAsLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  void startBikeTracking() async {
    await _locationTracker.getLocation();

    setState(() => TRACK_USER_ON_BIKE = true);
  }

  void markPlaceAsVisited(LatLng visitedPlace) async {
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);
    var tempPlaces = await data.getAllPlacesDocs();
    for (var currDoc in tempPlaces.docs) {
      LatLng currentDocLatLng =
          LatLng(double.parse(currDoc["Lat"]), double.parse(currDoc["Lng"]));
      if (visitedPlace == currentDocLatLng) {
        data.updateVisitedPlace(currDoc["PlaceID"]);
      }
    }
  }

  void getBikeDirectionsByFoot() async {
    clearMarkers();

    LatLng temp = await getCurrentLocationAsLatLng();
    var closestBP =
        await map_helpers.findClosestBikePoint(temp, NO_OF_PEOPLE, 0);
    startBikePoint = closestBP;
    print("updateStartBikePoint() IS CALLED");
    setState(() => searchForNewStartBP = true);
    updateStartBikePoint();

    var now = DateTime.now();
    var time = DateFormat("h:mma").format(now);

    addBikeMarker(closestBP.toString(), LatLng(closestBP.lat!, closestBP.lon!),
        "Bikes: ${closestBP.additionalProperties![6].value!}"
            ", Spaces: ${closestBP.additionalProperties![7].value!} (Updated $time)",
        closestBP.commonName!);
    var temp1 = await mapbox_walking.getWalkingRoute(
        temp, LatLng(closestBP.lat!, closestBP.lon!));
    List<LatLng> tempCoords = [];
    for (var t in temp1) {
      var tempLatLng = LatLng(t[1], t[0]);
      tempCoords.add(tempLatLng);
    }
    tempWalkingCoords = tempCoords;
    addPolyLine(tempWalkingCoords);

    //TODO: Display these instructions on screen
    var lst = await mapbox_walking.getTextInstructions(
        temp, LatLng(closestBP.lat!, closestBP.lon!));
    await _locationTracker.getLocation();
    setState(() => TRACK_USER_WALKING = true);
  }

  void getEndBikeDirections() async {
    clearMarkers();
    polylines.clear();

    LatLng temp = await getCurrentLocationAsLatLng();
    var closestBP =
        await map_helpers.findClosestBikePoint(temp, 0, NO_OF_PEOPLE);
    endBikePoint = closestBP;
    setState(() => searchForNewEndBP = true);
    updateEndBikePoint();

    var now = DateTime.now();
    var time = DateFormat("h:mma").format(now);

    addBikeMarker(closestBP.toString(), LatLng(closestBP.lat!, closestBP.lon!),
        "Bikes: ${closestBP.additionalProperties![6].value!}"
            ", Spaces: ${closestBP.additionalProperties![7].value!} (Updated $time)",
        closestBP.commonName!);

    var temp1 = await mapbox_cycling
        .getCyclingRouteUsingList([temp, placeToLatLng(closestBP)]);
    List<LatLng> tempCoords = temp1;
    polylineCoordinates = tempCoords;
    addPolyLine(polylineCoordinates);

    //TODO: possibly display text turn by turn instructions here
    await _locationTracker.getLocation();

    setState(() => TRACK_USER_LAST_LEG = true);
  }

  void startBikeJourney() async {
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);

    var temp = await data.getAllPlacesDocs();
    List<LatLng> itineraries = [];
    Map<LatLng, String> names = {};
    for (var element in temp.docs) {
      if (!element["isVisited"]) {
        itineraries.add(
            LatLng(double.parse(element["Lat"]), double.parse(element["Lng"])));
        names[LatLng(
                double.parse(element["Lat"]), double.parse(element["Lng"]))] =
            element["Name"];
      }
    }
    await getPolyline(itineraries, names);

    startBikeTracking();
  }

  void startJourney() async {
    if (userOnFoot) {
      getBikeDirectionsByFoot();
    }
    if (userOnBike) {
      startBikeJourney();
    }
  }

  Future<int> getNoOfPeople() async {
    var data = await DatabaseService(uid: _auth.getCurrent()?.uid);
    var temp = await data.getUserGroupSize();
    return temp;
  }

  void delayButton() async {
    setState(() => buttonDelay = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => buttonDelay = false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: Key("Map Home key"),
      future: globals.getTheme(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          mapIndex = snapshot.data;
          final pageOptions = [
            initMapState(),
            //RouteNameProvider(),
            FavouritesGrid(),
            ActivitiesProvider()
          ];
          // mapIndex = snapshot.data;
          return Scaffold(
            floatingActionButton: ValueListenableBuilder(
              valueListenable: globals.show,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? FloatingActionButton(
                        child: Icon(
                          Icons.navigation_sharp,
                          color: globals.textColours[mapIndex],
                        ),
                        backgroundColor: globals.themeColours[mapIndex],
                        onPressed: !JOURNEY_STARTED
                            ? () async {
                                String? groudId =
                                    await _auth.getCurrentUserGroupId();
                                if (groudId != "") {
                                  String leaderID = await DatabaseService(
                                          uid: _auth.getCurrent()?.uid,
                                          groupId: groudId)
                                      .getLeaderUID();
                                  if (leaderID != _auth.getCurrent()?.uid) {
                                    String? tempGroupId =
                                        await _auth.getCurrentUserGroupId();
                                    var tempDBS = DatabaseService(
                                        uid: _auth.getCurrent()?.uid,
                                        groupId: tempGroupId);
                                    var isJourneyStart =
                                        await tempDBS.getJourneyStarted();
                                    if (!(isJourneyStart)) {
                                      map_helpers.showCustomTextDialog(
                                          context,
                                          "Only the leader can start a journey",
                                          "Notice");
                                      return;
                                    }
                                  }
                                }
                                int visitedListSize =
                                    await getVisitedActivityListSize();
                                int activityListSize =
                                    await getAcitivityListSize();
                                if ((activityListSize - visitedListSize) < 1) {
                                  map_helpers.showActivityListDialog(context);
                                } else {
                                  if(buttonDelay){
                                    return;
                                  } else {
                                    delayButton();
                                  }
                                  await openInitialDialog();
                                  if (userOnFoot == userOnBike) return;
                                  var tempNum = await getNoOfPeople();
                                  setState(() => NO_OF_PEOPLE = tempNum);
                                  print("NO_OF_PEOPLE:  $NO_OF_PEOPLE");

                                  setState(() => JOURNEY_STARTED = true);
                                  startJourney();
                                  String? groupId =
                                      await _auth.getCurrentUserGroupId();
                                  if (groupId != "") {
                                    DatabaseService(
                                            uid: _auth.getCurrent()?.uid,
                                            groupId: groupId)
                                        .startJourney();
                                  }
                                }
                              }
                            : null)
                    : Container();
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: PageTransitionSwitcher(
                duration: Duration(seconds: 1),
                child: pageOptions[selectedPage],
                transitionBuilder: (child, animation, secondaryAnimation) =>
                    SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      fillColor: globals.themeColours[mapIndex],
                      child: child,
                    )),
            bottomNavigationBar: ValueListenableBuilder(
                valueListenable: globals.show,
                builder: (BuildContext context, bool value, Widget? child) {
                  return value
                      ? AnimatedBottomNavigationBar(
                          backgroundColor: globals.themeColours[mapIndex],
                          inactiveColor: globals.textColours[mapIndex],
                          activeColor: globals.textColours[mapIndex],
                          icons: iconList,
                          activeIndex: _selectedTab.index,
                          gapLocation: GapLocation.center,
                          notchSmoothness: NotchSmoothness.verySmoothEdge,
                          leftCornerRadius: 32,
                          rightCornerRadius: 32,
                          onTap: (index) {
                            _selectedTab = _SelectedTab.values[index];
                            switch (index) {
                              case (0):
                                {
                                  setState(() {
                                    currentIndex = 0;
                                    selectedPage = index;
                                  });
                                }
                                break;
                              case (1):
                                {
                                  setState(() {
                                    currentIndex = 1;
                                    selectedPage = index;
                                  });
                                }
                                break;
                              case (2):
                                {
                                  setState(() {
                                    currentIndex = 0;
                                    selectedPage = 0;
                                    Future.delayed(Duration(seconds: 1), () {
                                      SearchBar();
                                    });
                                  });
                                }
                                break;
                              case (3):
                                {
                                  setState(() {
                                    currentIndex = 2;
                                    selectedPage = 2;
                                  });
                                }
                                break;
                            }
                          },
                          //other params
                        )
                      : Container();
                }),
          );
        }
        return Loading();
      },
    );
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    textController.dispose();
    noOfBikesController.dispose();
    noOfEmptySpacesController.dispose();
    super.dispose();
  }

  showBikeConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget yesButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Your journey has begun"),
      actions: [
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget tempWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(
          width: 20.0,
        ),
        Flexible(
          child: TextField(
              key: Key("Number of bikes field"),
              keyboardType: TextInputType.number,
              controller: noOfBikesController,
              decoration: const InputDecoration(hintText: "No. bikes")),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Flexible(
          child: TextField(
              key: Key("Number of spaces field"),
              keyboardType: TextInputType.number,
              controller: noOfEmptySpacesController,
              decoration: const InputDecoration(hintText: "Empty spaces")),
        ),
      ],
    );
  }

  Future<void> showBikePointConfigurationDialog() => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Confirm"),
            content: tempWidget(),
            actions: [
              TextButton(
                child: Text("Submit"),
                onPressed: () {
                  var noOfBike_str = noOfBikesController.text;
                  var noOfEmptySpaces_str = noOfEmptySpacesController.text;
                  int noOfBike_int = 0;
                  int noOfEmptySpaces_int = 0;
                  try {
                    noOfBike_int = int.parse(noOfBike_str);
                    noOfEmptySpaces_int = int.parse(noOfEmptySpaces_str);
                    findNearestBikePoint(noOfBike_int, noOfEmptySpaces_int);
                  } catch (e) {
                    return;
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ));

  showCancelConfirmationDialog(BuildContext context) {
    material_dialog.Dialogs.materialDialog(
        msg: 'Are you sure you would like to cancel your journey?',
        title: "Cancel",
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'No',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(

            onPressed: () {
              cancelJourney();
              Navigator.pop(context);
            },

            text: 'Yes',
            iconData: Icons.check_outlined,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<void> openInitialDialog() => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Confirm"),
            content: Text("Are you starting the journey\non a Santander bike?"),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  setState(() => userOnBike = true);
                  setState(() => userOnFoot = false);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  setState(() => userOnBike = false);
                  setState(() => userOnFoot = true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}

enum _SelectedTab { home, favorite, search, activities, style }
