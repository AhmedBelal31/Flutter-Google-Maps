import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/location_info/lat_lng.dart';
import '../../data/models/location_info/location.dart';
import '../../data/models/location_info/location_info.dart';
import '../../data/models/place_autocomplete_model.dart';
import '../../data/models/place_details_model/place_details_model.dart';
import '../../data/models/routes_model/routes_model.dart';
import '../utils/new_marker.dart';
import 'google_maps_places_services.dart';
import 'location_service.dart';
import 'routes_services.dart';

class MapServices {
  LocationService locationService = LocationService();
  PlacesServices placesService = PlacesServices();
  RoutesService routesService = RoutesService();

  Future<void> fetchPredications({
    required String textEditingControllerValue,
    required String sessionToken,
    required List<PredictionsModel> places,
  }) async {
    if (textEditingControllerValue.isNotEmpty) {
      var result = await placesService.getPredications(
          input: textEditingControllerValue, sessionToken: sessionToken);
      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({
    required LatLng currentLocation,
    required LatLng destinationLocation,
  }) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
        ),
      ),
    );

    LocationInfoModel destination = LocationInfoModel(
        location: LocationModel(
      latLng: LatLngModel(
        latitude: destinationLocation.latitude,
        longitude: destinationLocation.longitude,
      ),
    ));
    RoutesModel routes = await routesService.fetchRoutes(
      origin: origin,
      destination: destination,
    );

    List<LatLng> routesPoints = getDecodedRoutes(routes);

    return routesPoints;
  }

  List<LatLng> getDecodedRoutes(RoutesModel routes) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints
        .decodePolyline(routes.routes!.first.polyline!.encodedPolyline!);
    List<LatLng> routesPoints =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return routesPoints;
  }

  void displayRoute(
    List<LatLng> routesPoints, {
    required Set<Polyline> myPolyLines,
    required GoogleMapController googleMapController,
  }) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      polylineId: const PolylineId('route'),
      points: routesPoints,
    );
    myPolyLines.add(route);

    LatLngBounds getLatLngBounds(List<LatLng> routesPoints) {
      var southwestLatitude = routesPoints.first.latitude;
      var southwestLongitude = routesPoints.first.longitude;
      var northeastLatitude = routesPoints.first.latitude;
      var northeastLongitude = routesPoints.first.longitude;

      for (int i = 0; i < routesPoints.length; i++) {
        if (routesPoints[i].latitude < southwestLatitude) {
          southwestLatitude = routesPoints[i].latitude;
        } else if (routesPoints[i].latitude > northeastLatitude) {
          northeastLatitude = routesPoints[i].latitude;
        }
      }

      for (int i = 0; i < routesPoints.length; i++) {
        if (routesPoints[i].longitude < southwestLongitude) {
          southwestLongitude = routesPoints[i].longitude;
        } else if (routesPoints[i].longitude > northeastLongitude) {
          northeastLongitude = routesPoints[i].longitude;
        }
      }
      return LatLngBounds(
        southwest: LatLng(southwestLatitude, southwestLongitude),
        northeast: LatLng(northeastLatitude, northeastLongitude),
      );
    }

    LatLngBounds latLngBounds = getLatLngBounds(routesPoints);
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 32));
  }

  Future<LatLng> updateCurrentLocation({
    required GoogleMapController googleMapController,
    required Set<Marker> myMarkers,
  }) async {
    var locationData = await locationService.getLocation();
    var currentLocation =
        LatLng(locationData.latitude!, locationData.longitude!);
    var myCameraPosition = CameraPosition(
      zoom: 16,
      target: currentLocation,
    );
    var myMarker = newMarker(
      id: 'myMarker21',
      latLng: LatLng(locationData.latitude!, locationData.longitude!),
    );
    myMarkers.add(myMarker);
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(myCameraPosition),
    );
    return currentLocation;
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var placeDetails = await placesService.getPlaceDetails(
      placeId: placeId,
    );

    return placeDetails;
  }

// Future<void> updateMyLocation(context) async {
//   bool isServiceEnabled =
//       await locationService.checkAndRequestLocationService();
//   if (!isServiceEnabled) {
//     showErrorSnackBar(context, text: 'Check Service Location');
//   }
//   var hasPermission =
//       await locationService.checkAndRequestLocationPermission();
//   if (hasPermission) {
//     locationService.getRealTimeLocationData((locationData) {
//       setMyLocationMarker(locationData);
//       changeMyNewCameraPosition(locationData);
//     });
//   } else {
//     showErrorSnackBar(context,
//         text: 'You Don\'t Real-Time Location Permission ');
//   }
// }
//
// void changeMyNewCameraPosition(LocationData locationData) {
//   if (isFirstCall) {
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(
//         locationData.latitude!,
//         locationData.longitude!,
//       ),
//       zoom: 17,
//     );
//     googleMapController
//         ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//     isFirstCall = false;
//   } else {
//     googleMapController?.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(
//           locationData.latitude!,
//           locationData.longitude!,
//         ),
//       ),
//     );
//   }
// }
//
// void setMyLocationMarker(LocationData locationData) {
//   var myLocationMarker = newMarker(
//     id: 'locationMarker',
//     latLng: LatLng(locationData.latitude!, locationData.longitude!),
//   );
//   setState(() {
//     myMarkers.add(myLocationMarker);
//   });
// }

// addMarkers() async {
//   BitmapDescriptor image = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     'assets/images/icons8-marker-50.png',
//   );
//
//   myMarkers.addAll(
//     placeModels
//         .map(
//           (place) => Marker(
//             markerId: MarkerId(place.id.toString()),
//             position: place.latLng,
//             // icon: image,
//             infoWindow: InfoWindow(
//               title: place.name,
//             ),
//           ),
//         )
//         .toSet(),
//   );
//   setState(() {});
// }
}
