import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/core/services/location_service.dart';
import 'package:flutter_with_google_maps/data/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../core/services/google_maps_places_services.dart';
import '../../core/utils/custom_snak_bar.dart';
import '../../core/utils/new_marker.dart';
import '../../data/models/place_autocomplete_model.dart';
import 'custom_text_field.dart';

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

  // bool isFirstCall = true;
  var myMarkers = <Marker>{};

  // Set<Polyline> myPolyLines = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(31.20632194391642, 29.911010868194964),
      zoom: 1,
    );
    //addMarkers();
    // addPolyLines();
    locationService = LocationService();
    textEditingController = TextEditingController();
    googleMapsPlacesServices = GoogleMapsPlacesServices();
    textEditingController.addListener(() => fetchPredications());

    super.initState();
  }

  void fetchPredications() async {
    if (textEditingController.text.isNotEmpty) {
      var result = await googleMapsPlacesServices.getPredications(
        input: textEditingController.text,
      );
      places.clear();
      places.addAll(result);
      setState(() {});
    } else {
      places.clear();
      setState(() {});
    }
  }

  // void fetchPredications() {
  //   textEditingController.addListener(() async {
  //     if (textEditingController.text.isNotEmpty) {
  //       var result = await googleMapsPlacesServices.getPredications(
  //           input: textEditingController.text);
  //       print(result);
  //     }
  //
  //   });
  // }

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

  // addPolyLines() {
  //   myPolyLines.add(
  //     const Polyline(
  //       polylineId: PolylineId('1'),
  //       width: 2,
  //       endCap: Cap.roundCap,
  //       // geodesic: true,
  //       startCap: Cap.squareCap,
  //       // jointType: JointType.mitered,
  //       color: Colors.red,
  //       points: [
  //         LatLng(31.197765986988546, 29.899822747599988),
  //         LatLng(31.201296109318136, 29.91396385665663),
  //         LatLng(31.209290311153776, 29.920154385084857),
  //         LatLng(31.21505194669606, 29.924099329671478),
  //       ],
  //     ),
  //   );
  // }

  void loadMapStyle() async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map_style.json');

    await googleMapController!.setMapStyle(mapStyle);
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
                loadMapStyle();
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();
      var myCameraPosition = CameraPosition(
        zoom: 16,
        target: LatLng(locationData.latitude!, locationData.longitude!),
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
      print('LocationServiceException');
      // TODO
    } on LocationPermissionException catch (e) {
      // TODO
      print('LocationPermissionException');
    } catch (e) {}
  }
}

class PlacesListView extends StatelessWidget {
  final List<PredictionsModel> places;

  const PlacesListView({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            title: Text(places[index].description!),
            leading: const Icon(
              Icons.location_on_outlined,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 8,
      ),
      itemCount: places.length,
    );
  }
}
