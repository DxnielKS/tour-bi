import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "dart:convert";

class MapBox extends StatefulWidget {
  final List<LatLng> routeWaypoints;
  const MapBox({Key? key, required this.routeWaypoints}) : super(key: key);

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  // Waypoints to mark trip start and end
  var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  bool isMultipleStop = true;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.cycling,
        isOptimized: false,
        units: VoiceUnits.metric,
        simulateRoute: false,
        language: "en");

    for (var w in widget.routeWaypoints) {
      wayPoints.add(WayPoint(
          name: w.toString(), latitude: w.latitude, longitude: w.longitude));
    }

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    // getLocation();
    return Container(
      color: Colors.grey,
      child: MapBoxNavigationView(
          options: _options,
          onRouteEvent: _onRouteEvent,
          onCreated: (MapBoxNavigationViewController controller) async {
            _controller = controller;
          }),
    );
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        setState(() {});
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          routeBuilt = false;
          isNavigating = false;
          Navigator.pop(context);
        });
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
