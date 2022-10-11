class Place{
  final String address;
  final String lat;
  final String lng;
  final String name;
  final List<dynamic> photoreferences;
  final String placeId;
  final String rating;

  Place ({required this.placeId,required this.lng, required this.lat, required this.rating, required this.name, required this.address, required this.photoreferences});


  factory Place.fromJson(Map<String, dynamic> data) {
    return Place(
        address: data['address'],
        lat: data['latitude'],
        lng: data['longitude'],
        name: data['name'],
        photoreferences: data['photoreferences'],
        placeId: data['placeId'],
        rating: data['rating']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'address':address,
      'latitude':lat,
      'longitude':lng,
      'name':name,
      'photoreferences':photoreferences,
      'placeId':placeId,
      'rating':rating
    };
  }


}