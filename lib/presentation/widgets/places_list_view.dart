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
        return PlacesListViewItem(
          index: index,
          places: places,
          googleMapsPlacesServices: googleMapsPlacesServices,
          onPlaceSelected: onPlaceSelected,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 8,
      ),
      itemCount: places.length,
    );
  }
}

class PlacesListViewItem extends StatelessWidget {
  const PlacesListViewItem({
    super.key,
    required this.places,
    required this.googleMapsPlacesServices,
    required this.onPlaceSelected,
    required this.index,
  });

  final int index;
  final List<PredictionsModel> places;
  final GoogleMapsPlacesServices googleMapsPlacesServices;
  final Function(PlaceDetailsModel p1) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        {
          var placeDetails = await googleMapsPlacesServices.getPlaceDetails(
              placeId: places[index].placeId!);
          onPlaceSelected(placeDetails);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(places[index].description!),
          leading: const Icon(
            Icons.location_on_outlined,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
          ),
        ),
      ),
    );
  }
}
