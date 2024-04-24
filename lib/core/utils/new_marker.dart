import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker newMarker({required String id, required LatLng latLng}) {
  return Marker(markerId: MarkerId(id), position: latLng);
}