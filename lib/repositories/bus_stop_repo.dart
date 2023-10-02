import 'dart:convert';

import 'package:pv_analizer/models/busStop.dart';

import 'package:http/http.dart' as http;

class BusStopRepo {
  final String url = 'https://demo1.drt.kia.prz.edu.pl/api/BusStop/';
  Future<List<BusStop>> getBusStop() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;

      final result = json.map((e) {
        return BusStop(
          idBusStop: e['id_bus_stop'],
          codeStop: e['code_stop'],
          city: e['city'],
          name: e['name'],
          gpsN: e['gps_n'],
          gpsE: e['gps_e'],
          loop: e['loop'],
          waitTime: e['wait_time'],
          chargerKw: e['charger_kw'],
        );
      }).toList();

      return result;
    } else {
      throw '${response.statusCode}';
    }
  }

  // Future<List<BusStop>> BusStopByIdCourse(int IdCourse) async {
  //   final busStops = await getBusStop();
  //   return busStops.where((busStop) => busStop['id_course'])
  // }
}
