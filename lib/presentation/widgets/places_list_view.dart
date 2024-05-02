import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/core/services/google_maps_places_services.dart';
import 'package:flutter_with_google_maps/core/services/map_services.dart';
import 'package:flutter_with_google_maps/data/models/place_details_model/place_details_model.dart';
import '../../data/models/place_autocomplete_model.dart';
import 'places_list_view_item.dart';

class PlacesListView extends StatelessWidget {
  final List<PredictionsModel> places;
  final MapServices mapServices;
  final Function(PlaceDetailsModel) onPlaceSelected;

  const PlacesListView({
    super.key,
    required this.places,
    required this.mapServices,
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
          mapServices: mapServices,
          places: places,
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
