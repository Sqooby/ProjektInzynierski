import 'package:flutter/material.dart';
import 'package:pv_analizer/screens/BusStop/bus_stop_body.dart';

class BusStopScreen extends StatelessWidget {
  const BusStopScreen({Key? key}) : super(key: key);
  static const String route = '/busStop';

  @override
  Widget build(BuildContext context) {
    return BusStopBody();
  }
}
