import 'dart:convert';
import 'package:flutter_with_google_maps/data/models/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;
import '../utils/api_key.dart';

class GoogleMapsPlacesServices {
  Future<List<PredictionsModel>> getPredications(
      {required String input}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place';

    var response = await http
        .get(Uri.parse('$baseUrl/autocomplete/json?input=$input&key=$apiKey'));

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
      throw Exception();
    }
  }
}
