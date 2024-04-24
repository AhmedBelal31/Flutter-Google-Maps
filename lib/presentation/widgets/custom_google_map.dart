import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/data/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;

  Set<Marker> myMarkers = {};
  Set<Polyline> myPolyLines = {};

  late Location location;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(31.20632194391642, 29.911010868194964),
      zoom: 14,
    );
    addMarkers();
    // addPolyLines();
    location = Location();
    updateMyLocation(context);
  }

  ///First Step .
  ///Check  Location Service on Mobile
  //if(its Not enabled , Ask For enable )
  //if user Denied -> Show snakbar error

  ///Second Step
  ///Check  Location Permission on Application
  // if - he has a Permission
  //   Check if user Denied For one time -> Ask for permission
  // if user not accepted again -> Not Granted (denied or denied forever )
  //Show error

  Future<bool> checkAndRequestLocationService() async {
    bool isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      isEnabled = await location.requestService();
      if (!isEnabled) {
        //ToDO: Show Error Bar (Error , OR Don't Have Access ) ;
        return false;
      }
      return true;
    }
    return true;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      if (permissionStatus != PermissionStatus.granted) {
        ///ToDO: Show Error Bar (Error , OR Don't Have Access ) ;
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  void getLocationData() {
    //Request a new location every 2 meter
    // store previous location and compare with current Location
    //update if current>2m of Previous Location

    location.changeSettings(
      distanceFilter: 50,
    );
    location.onLocationChanged.listen((locationData) {
      var myLocationMarker = Marker(
          markerId: const MarkerId('locationMarker'),
          position: LatLng(
            locationData.latitude!,
            locationData.longitude!,
          ));

      setState(() {
        myMarkers.add(myLocationMarker);
      });
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locationData.latitude!,
              locationData.longitude!,
            ),
            zoom: 14,
          ),
        ),
      );
    });
  }

  Future<void> updateMyLocation(context) async {
    bool isServiceEnabled = await checkAndRequestLocationService();
    if (isServiceEnabled) {
      bool hasPermission = await checkAndRequestLocationPermission();
      if (hasPermission) {
        getLocationData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You Don\'t have Permission '),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Check Service Location '),
      ));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // mapType: MapType.satellite   ,
        initialCameraPosition: initialCameraPosition,
        // polylines: myPolyLines,
        onMapCreated: (controller) {
          googleMapController = controller;
          loadMapStyle();
        },
        markers: myMarkers,
      ),
    );
  }
}
