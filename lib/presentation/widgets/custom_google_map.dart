import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/core/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/map_services.dart';
import '../../data/models/place_autocomplete_model.dart';
import 'custom_text_field.dart';
import 'places_list_view.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late TextEditingController textEditingController;
  List<PredictionsModel> places = [];
  late Uuid uuid;
  String? sessionToken;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  Set<Marker> myMarkers = {};
  Set<Polyline> myPolyLines = {};
  late MapServices mapServices;
  Timer? debounce;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(31.20632194391642, 29.911010868194964),
      zoom: 1,
    );
    //addMarkers();
    uuid = const Uuid();
    textEditingController = TextEditingController();
    textEditingController.addListener(() => fetchPredications());
    mapServices = MapServices();
    super.initState();
  }

  void fetchPredications() {
    debounce = Timer(
      const Duration(milliseconds: 200),
      () async {
        if (debounce?.isActive ?? false) {
          debounce?.cancel();
        }
        sessionToken ??= uuid.v4();
        await mapServices.fetchPredications(
          textEditingControllerValue: textEditingController.text,
          sessionToken: sessionToken!,
          places: places,
        );
      },
    );

    setState(() {});
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void loadMapStyle() async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map_style.json');

    await googleMapController!.setMapStyle(mapStyle);
  }

  void updateCurrentLocation() async {
    try {
      currentLocation = await mapServices.updateCurrentLocation(
        googleMapController: googleMapController!,
        myMarkers: myMarkers,
      );
      setState(() {});
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
        floatingActionButton: googleMapController != null
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    updateCurrentLocation();
                  });
                },
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF242F3E),
                ),
              )
            : null,
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: initialCameraPosition,
              polylines: myPolyLines,
              onMapCreated: (controller) {
                googleMapController = controller;
                loadMapStyle();
                updateCurrentLocation();
              },
              markers: myMarkers,
            ),
            googleMapController != null
                ? Positioned(
                    top: 16,
                    right: 16,
                    left: 16,
                    child: Column(
                      children: [
                        CustomTextField(
                            textEditingController: textEditingController),
                        const SizedBox(height: 20),
                        PlacesListView(
                          places: places,
                          mapServices: mapServices,
                          onPlaceSelected: (placeDetailsModel) async {
                            sessionToken = null;
                            textEditingController.clear();
                            places.clear();
                            FocusScope.of(context).unfocus();
                            destinationLocation = LatLng(
                              placeDetailsModel.geometry!.location!.lat!,
                              placeDetailsModel.geometry!.location!.lng!,
                            );

                            var routesPoints = await mapServices.getRouteData(
                              currentLocation: currentLocation,
                              destinationLocation: destinationLocation,
                            );
                            mapServices.displayRoute(
                              routesPoints,
                              myPolyLines: myPolyLines,
                              googleMapController: googleMapController!,
                            );

                            Marker myDestinationMarker = Marker(
                              markerId: const MarkerId(
                                'destinationLocation',
                              ),
                              position: destinationLocation,
                            );
                            myMarkers.add(myDestinationMarker);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
