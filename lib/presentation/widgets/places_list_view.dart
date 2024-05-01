import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/core/services/google_maps_places_services.dart';
import 'package:flutter_with_google_maps/data/models/place_details_model/place_details_model.dart';

import '../../data/models/place_autocomplete_model.dart';

class PlacesListView extends StatelessWidget {
  final List<PredictionsModel> places;
  final GoogleMapsPlacesServices googleMapsPlacesServices;
  final Function(PlaceDetailsModel) onPlaceSelected;

  const PlacesListView({
    super.key,
    required this.places,
    required this.googleMapsPlacesServices,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,

              borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            title: Text(places[index].description!),
            leading: const Icon(
              Icons.location_on_outlined,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios ,),
              onPressed: () async {
                var placeDetails = await googleMapsPlacesServices
                    .getPlaceDetails(
                    placeId: places[index].placeId!
                );
                onPlaceSelected(placeDetails);
              },
            ),
          ),
        );
      },
      separatorBuilder: (context, index) =>
      const SizedBox(
        height: 8,
      ),
      itemCount: places.length,
    );
  }
}
