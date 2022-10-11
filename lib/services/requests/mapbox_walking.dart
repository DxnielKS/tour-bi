import "package:http/http.dart" as http;
import "package:google_maps_flutter/google_maps_flutter.dart";
import "dart:convert";

const String key =
    "pk.eyJ1IjoiZGF3dWRvc21hbiIsImEiOiJjbDEwdnFvaWYyaDAyM2Nqd3J4OXZscG1pIn0.NvqZOkwZlNkDOpNzk6OSew";

Future getWalkingRoute(LatLng s, LatLng d) async {
  String url = "https://api.mapbox.com/directions/v5/mapbox/walking/"
      "${s.longitude},${s.latitude};${d.longitude},${d.latitude}"
      "?geometries=geojson&language=en&overview=full&steps=true&access_token=$key";

  print(url);

  try {
    var mapboxPoly = await http.get(Uri.parse(url));
    var lst =
        jsonDecode(mapboxPoly.body)["routes"][0]["geometry"]["coordinates"];
    return lst;
  } catch (e) {
    print("ERROR ERROR");
    print(e.toString());
    print("\n\n\n\n\n\n\n\n\n\n");
    for (int i = 0; i < 10; i++) {
      print("ERROR AT getWalkingRoute() in mapbox_Walking.dart");
    }
    ;
  }
}

Future getTextInstructions(LatLng s, LatLng d) async {
  String url = "https://api.mapbox.com/directions/v5/mapbox/walking/"
      "${s.longitude},${s.latitude};${d.longitude},${d.latitude}"
      "?geometries=geojson&language=en&overview=full&steps=true&access_token=$key";

  print(url);
  try {
    List<String> instructions = [];
    var mapboxPoly = await http.get(Uri.parse(url));
    var lst = jsonDecode(mapboxPoly.body)["routes"][0]["legs"];
    for (var l in lst) {
      var steps = l["steps"];
      for (var s in steps) {
        var temp = s["maneuver"]["instruction"];
        instructions.add(temp);
      }
    }
    return instructions;
  } catch (e) {
    print(e.toString());
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n");
    for (int i = 0; i < 10; i++) {
      print("ERROR ON getTextInstructions() in mapbox_walking.dart");
    }
    ;
  }
}
