import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkUtility {
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
}
