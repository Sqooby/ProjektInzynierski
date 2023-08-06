// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pv_analizer/logic/models/autocomplete_prediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;
  PlaceAutocompleteResponse({
    this.status,
    this.predictions,
  });
  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? json['predictions'].map<AutocompletePrediction>((json) => AutocompletePrediction.fromJson(json)).toList()
          : null,
    );
  }
  static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
