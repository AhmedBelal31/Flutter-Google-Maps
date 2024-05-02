import 'package:flutter/material.dart';
import '../../core/services/map_services.dart';
import '../../data/models/place_autocomplete_model.dart';
import '../../data/models/place_details_model/place_details_model.dart';

class PlacesListViewItem extends StatelessWidget {
  const PlacesListViewItem({
    super.key,
    required this.index,
    required this.mapServices,
    required this.places,
    required this.onPlaceSelected,
  });

  final int index;
  final MapServices mapServices;
  final List<PredictionsModel> places;
  final Function(PlaceDetailsModel p1) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        {
          var placeDetails = await mapServices.getPlaceDetails(
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
