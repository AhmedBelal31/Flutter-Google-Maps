import 'dart:convert';
import 'package:flutter_with_google_maps/data/models/place_autocomplete_model.dart';
import 'package:flutter_with_google_maps/data/models/place_details_model/place_details_model.dart';
import 'package:http/http.dart' as http;
import '../utils/api_key.dart';

class GoogleMapsPlacesServices {
  Future<List<PredictionsModel>> getPredications(
      {required String input, required sessionToken}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place';

    var response = await http
        .get(
      Uri.parse(
        '$baseUrl/autocomplete/json?input=$input&sessiontoken=$sessionToken&components=country:eg&key=$apiKey',
      ),
    )
        .timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      // List<PredictionsModel> places = [];
      // for (var placeItem in data) {
      //   places.add(PredictionsModel.fromJson(placeItem));
      // }
      // return places ;

      List<PredictionsModel> places = List<PredictionsModel>.from(
          data.map((placeItem) => PredictionsModel.fromJson(placeItem)));

      return places;
    } else {
      print('error here !');
      throw Exception('No Places Found !');
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place';

    var response = await http
        .get(Uri.parse('$baseUrl/details/json?place_id=$placeId&key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(data);
      return placeDetails;
    } else {
      throw Exception();
    }
  }
}
