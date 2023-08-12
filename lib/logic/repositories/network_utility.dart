import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pv_analizer/logic/models/autocomplete_prediction.dart';

import '../models/place_auto_complate_response.dart';

class NetworkUtility {
  List<AutocompletePrediction> currentLocationPredictions = [];
  List<AutocompletePrediction> destinationLocationPredictions = [];
  Future<String>? fetchUrl(Uri uri, {Map<String, String>? headres}) async {
    try {
      final response = await http.get(uri, headers: headres);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  void placeAutoComplete(String query, bool isCurrentLocation) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc',
        'language': 'pl',
      },
    );

    String? response = await NetworkUtility().fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        if (isCurrentLocation) {
          currentLocationPredictions = result.predictions!;
        } else {
          destinationLocationPredictions = result.predictions!;
        }
      }
      print(currentLocationPredictions);
    }
  }
}
