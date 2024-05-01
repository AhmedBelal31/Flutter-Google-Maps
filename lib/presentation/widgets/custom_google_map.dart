import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_with_google_maps/core/services/location_service.dart';
import 'package:flutter_with_google_maps/core/services/routes_services.dart';
import 'package:flutter_with_google_maps/data/models/location_info/lat_lng.dart';
import 'package:flutter_with_google_maps/data/models/location_info/location.dart';
import 'package:flutter_with_google_maps/data/models/location_info/location_info.dart';
import 'package:flutter_with_google_maps/data/models/place_model.dart';
import 'package:flutter_with_google_maps/data/models/routes_model/routes_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/google_maps_places_services.dart';
import '../../core/utils/new_marker.dart';
import '../../data/models/place_autocomplete_model.dart';
import '../../data/models/routes_model/route.dart';
import 'custom_text_field.dart';
import 'places_list_view.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  late GoogleMapsPlacesServices googleMapsPlacesServices;
  List<PredictionsModel> places = [];
  late Uuid uuid;
  String? sessionToken;

  late RoutesService routesService;

  late LatLng currentLocation;

  late LatLng destinationLocation;

  // bool isFirstCall = true;
  var myMarkers = <Marker>{};

  Set<Polyline> myPolyLines = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(31.20632194391642, 29.911010868194964),
      zoom: 1,
    );
    //addMarkers();
    // addPolyLines();
    uuid = Uuid();
    locationService = LocationService();
    textEditingController = TextEditingController();
    googleMapsPlacesServices = GoogleMapsPlacesServices();
    textEditingController.addListener(() => fetchPredications());
    routesService = RoutesService();
    super.initState();
  }

  void fetchPredications() async {
    sessionToken ??= uuid.v4();
    if (textEditingController.text.isNotEmpty) {
      var result = await googleMapsPlacesServices.getPredications(
          input: textEditingController.text, sessionToken: sessionToken!);

      places.clear();
      places.addAll(result);
      setState(() {});
    } else {
      places.clear();
      setState(() {});
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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

  addMarkers() async {
    BitmapDescriptor image = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/icons8-marker-50.png',
    );

    myMarkers.addAll(
      placeModels
          .map(
            (place) => Marker(
              markerId: MarkerId(place.id.toString()),
              position: place.latLng,
              // icon: image,
              infoWindow: InfoWindow(
                title: place.name,
              ),
            ),
          )
          .toSet(),
    );
    setState(() {});
  }

  addPolyLines() {
    myPolyLines.add(
      const Polyline(
        polylineId: PolylineId('1'),
        width: 2,
        endCap: Cap.roundCap,
        // geodesic: true,
        startCap: Cap.squareCap,
        // jointType: JointType.mitered,
        color: Colors.red,
        points: [
          LatLng(31.197765986988546, 29.899822747599988),
          LatLng(31.201296109318136, 29.91396385665663),
          LatLng(31.209290311153776, 29.920154385084857),
          LatLng(31.21505194669606, 29.924099329671478),
        ],
      ),
    );
  }

  void loadMapStyle() async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map_style.json');

    await googleMapController!.setMapStyle(mapStyle);
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      var myCameraPosition = CameraPosition(
        zoom: 16,
        target: currentLocation,
      );
      var myMarker = newMarker(
        id: 'myMarker21',
        latLng: LatLng(locationData.latitude!, locationData.longitude!),
      );
      myMarkers.add(myMarker);
      setState(() {});
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(myCameraPosition),
      );
    } on LocationServiceException catch (e) {
      // TODO
    } on LocationPermissionException catch (e) {
      // TODO
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              // polylines: myPolyLines,
              onMapCreated: (controller) {
                googleMapController = controller;
                // loadMapStyle();
                updateCurrentLocation();
              },
              markers: myMarkers,
            ),
            Positioned(
              top: 16,
              right: 16,
              left: 16,
              child: Column(
                children: [
                  CustomTextField(textEditingController: textEditingController),
                  const SizedBox(height: 20),
                  PlacesListView(
                    places: places,
                    googleMapsPlacesServices: googleMapsPlacesServices,
                    onPlaceSelected: (placeDetailsModel) {
                      // sessionToken=null ;
                      // print(placeDetailsModel.adrAddress);
                      textEditingController.clear();
                      places.clear();
                      destinationLocation = LatLng(
                          placeDetailsModel.geometry!.location!.lat!,
                          placeDetailsModel.geometry!.location!.lng!);
                      getRouteData();
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<LatLng>> getRouteData() async {
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
}
