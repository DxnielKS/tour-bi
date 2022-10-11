import 'Place.dart';

class Route{
  final String name;
  final List<Place> places;

  Route ({ required this.name,required this.places });

  factory Route.fromJson(Map<String, dynamic> data) {
    List<dynamic> list = data['places'] ?? [];

    final places = list.map((e) => Place.fromJson(e)).toList();

    return Route(
      name: data['name'],
      places: places,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'places': places.map((e) => e.toJson()).toList(),
    };
  }

}