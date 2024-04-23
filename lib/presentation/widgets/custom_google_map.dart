import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/data/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;

  Set<Marker> myMarkers = {};

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(31.20632194391642, 29.911010868194964),
      zoom: 15,
    );
    addMarkers();
  }

  addMarkers() {
    myMarkers.addAll(
      placeModels
          .map(
            (place) => Marker(
              markerId: MarkerId(place.id.toString()),
              position: place.latLng,
              infoWindow: InfoWindow(
                title: place.name,
              ),
            ),
          )
          .toSet(),
    );
  }

  void loadMapStyle() async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map_style.json');
    await googleMapController.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // mapType: MapType.satellite   ,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (controller) {
          googleMapController = controller;
          loadMapStyle();
        },
        markers: myMarkers,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_with_google_maps/data/models/place_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class CustomGoogleMap extends StatefulWidget {
//   const CustomGoogleMap({Key? key}) : super(key: key);
//
//   @override
//   State<CustomGoogleMap> createState() => _CustomGoogleMapState();
// }
//
// class _CustomGoogleMapState extends State<CustomGoogleMap> {
//   late CameraPosition initialCameraPosition;
//   late GoogleMapController googleMapController;
//
//   Set<Marker> myMarkers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     initialCameraPosition = const CameraPosition(
//       target: LatLng(31.20632194391642, 29.911010868194964),
//       zoom: 15,
//     );
//     addMarkers();
//   }
//
//   addMarkers() {
//     myMarkers.addAll(
//       placeModels
//           .map(
//             (place) => Marker(
//           markerId: MarkerId(place.id.toString()),
//           position: place.latLng,
//           onTap: () {
//             // Show snack bar when marker is tapped
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(place.name),
//               ),
//             );
//           },
//         ),
//       )
//           .toSet(),
//     );
//   }
//
//   void loadMapStyle() async {
//     String mapStyle = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/dark_map_style.json');
//     await googleMapController.setMapStyle(mapStyle);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: initialCameraPosition,
//         onMapCreated: (controller) {
//           googleMapController = controller;
//           loadMapStyle();
//         },
//         markers: myMarkers,
//       ),
//     );
//   }
// }
