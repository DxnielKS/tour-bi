import "package:http/http.dart" as http;
import "package:google_maps_flutter/google_maps_flutter.dart";
import "dart:convert";

const String key =
    "pk.eyJ1IjoiZGF3dWRvc21hbiIsImEiOiJjbDEwdnFvaWYyaDAyM2Nqd3J4OXZscG1pIn0.NvqZOkwZlNkDOpNzk6OSew";

Future getCyclingRoute(String inLatLngs) async {
  List<LatLng> polylineCoordinates = [];
  String url = "https://api.mapbox.com/directions/v5/mapbox/cycling/$inLatLngs"
      "/?alternatives=false&continue_straight=true&geometries=geojson&language"
      "=en&overview=full&steps=true&access_token="
      "$key";

  print(url);

  try {
    var mapboxPoly = await http.get(Uri.parse(url));
    var lst =
        jsonDecode(mapboxPoly.body)["routes"][0]["geometry"]["coordinates"];
    for (var l in lst) {
      var tempList = List<double>.from(l);
      polylineCoordinates.add(LatLng(tempList[1], tempList[0]));
    }
    return polylineCoordinates;
    print(url);
  } catch (e) {
    print(e.toString());
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n");
    for (int i = 0; i < 10; i++) {
      print("ERROR ON getCyclingRoute() in mapbox_cycling.dart");
    }
    ;
  }
}

Future getCyclingRouteUsingList(List<LatLng> inList) async {
  List<LatLng> polylineCoordinates = [];
  String latLngs = "";

  for (int i = 0; i < inList.length - 1; i++) {
    latLngs += "${inList[i].longitude},${inList[i].latitude};";
  }
  latLngs += "${inList.last.longitude},${inList.last.latitude}";

  String url = "https://api.mapbox.com/directions/v5/mapbox/cycling/$latLngs"
      "/?alternatives=false&continue_straight=true&geometries=geojson&language"
      "=en&overview=full&steps=true&access_token="
      "$key";

  print(url);

  try {
    var mapboxPoly = await http.get(Uri.parse(url));
    var lst =
        jsonDecode(mapboxPoly.body)["routes"][0]["geometry"]["coordinates"];
    for (var l in lst) {
      var tempList = List<double>.from(l);
      polylineCoordinates.add(LatLng(tempList[1], tempList[0]));
    }
    return polylineCoordinates;
    print(url);
  } catch (e) {
    print(e.toString());
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n");
    for (int i = 0; i < 10; i++) {
      print("ERROR ON getCyclingRouteUsingList() in mapbox_cycling.dart");
    }
    ;
  }
}
