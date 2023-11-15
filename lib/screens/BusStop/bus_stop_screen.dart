import 'package:flutter/material.dart';
import 'package:pv_analizer/screens/BusStop/bus_stop_body.dart';

class BusStopScreen extends StatelessWidget {
  final Map<String, List<dynamic>> courseMap;
  const BusStopScreen({Key? key, required this.courseMap}) : super(key: key);
  static const String route = '/busStop';

  @override
  Widget build(BuildContext context) {
    return BusStopBody(
      courseMap: courseMap,
    );
  }
}
