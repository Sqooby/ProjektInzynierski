import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;

class LocationService {
  final String? key = dotenv.env['API_KEY'];
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

    return result;
  }

  Future<List<String>> getAutocompleteLocation(String input) async {
    String location = '50.041187,21.999121'; // Lokalizacja dla Rzeszowa
    String radius = '300'; // Promień wyszukiwania w metrach
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$key&radius=$radius&location=$location';
    var response = await http.get(Uri.parse(url));
    try {
      var json = convert.jsonDecode(response.body);
      List<String> places = [];
      for (var predictions in json['predictions']) {
        places.add(predictions['description']);
      }
      return places;
    } catch (e) {
      throw 'e';
    }
  }
}
