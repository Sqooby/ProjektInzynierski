import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/BusStopTime.dart';

class BusStopTimeRepo {
  final String url = 'https://demo1.drt.kia.prz.edu.pl/api/BusStopsTime/';
  Future<List<BusStopTime>> getBusStopTime() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final result = json.map((e) {
        return BusStopTime(
          e['id_bus_stop_time'],
          e['id_bus_stop_start'],
          e['id_bus_stop_end'],
          e['hour'],
          e['time'],
        );
      }).toList();
      print(result[0].time);
      return result;
    } else {
      throw '${response.statusCode}';
    }
  }
}
