// IDK if this code is needed anymore

class GeoLocation {
  // latitude, longitude, and a link to an img.
  // remove radius, not needed with the updated game loop
  int? id;
  double? lat;
  double? long;
  String? imgLink;

  GeoLocation({this.id, this.lat, this.long, this.imgLink});

  GeoLocation.fromMap(Map map) {
    id = map['id'];
    lat = map['lat'];
    long = map['long'];
    imgLink = map['imgLink'];
  }

  Map<String,Object?> toMap() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
      'imgLink': imgLink,
    };
  }

  @override
  String toString(){
    return 'Location: [$lat,$long] $imgLink';
  }
}