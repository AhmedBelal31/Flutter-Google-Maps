import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;

  final String name;

  final LatLng latLng;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> placeModels =const [
  PlaceModel(
    id: 1,
    name: 'كازينو الشاطبي',
    latLng: LatLng(31.212658026133695, 29.91528097642947),
  ),

  PlaceModel(
    id: 2,
    name: 'كليه الهندسه',
    latLng: LatLng(31.20656507563046, 29.92356363776359),
  ),

  PlaceModel(
    id: 3,
    name: 'مطعم البركه',
    latLng: LatLng(31.21468723171336, 29.92215749941917),
  ),



];
