import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc';
  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var placeId = json['results'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = json['result'] as Map<String, dynamic>;

    return result;
  }

  Future<Map<String, dynamic>> getDirections(String origin, String desination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$desination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
    print(result);

    return result;
  }

  // List<AutocompletePrediction> currentLocationPredictions = [];
  // List<AutocompletePrediction> destinationLocationPredictions = [];
  // Future<String>? fetchUrl(Uri uri, {Map<String, String>? headres}) async {
  //   try {
  //     final response = await http.get(uri, headers: headres);
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   return '';
  // }

  // void placeAutoComplete(String query, bool isCurrentLocation) async {
  //   Uri uri = Uri.https(
  //     'maps.googleapis.com',
  //     '/maps/api/place/autocomplete/json',
  //     {
  //       'input': query,
  //       'key': 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc',
  //       'language': 'pl',
  //     },
  //   );

  //   String? response = await NetworkUtility().fetchUrl(uri);
  //   if (response != null) {
  //     PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
  //     if (result.predictions != null) {
  //       if (isCurrentLocation) {
  //         currentLocationPredictions = result.predictions!;
  //       } else {
  //         destinationLocationPredictions = result.predictions!;
  //       }
  //     }
  //   }
  // }

  // Future<Map<String, dynamic>> getPlace(String input) async {

  //   Uri uri = Uri.https(
  //     'maps.googleapis.com',
  //     '/maps/api/place/details/json',
  //     {
  //       'place_id': placeId,
  //       'key': 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc',
  //     },
  //   );
  //   var response = await http.get(uri);
  //   var json = convert.jsonDecode(response.body);
  //   var result = json['result'] as Map<String, dynamic>;
  //   print(result);
  //   return result;
  // }
}
