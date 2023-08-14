import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding/google_geocoding.dart';

import '../widgets/home_drawer.dart';

class MapScreen extends StatefulWidget {
  static String routeName = '/map';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const LatLng destination = LatLng(50.036266, 21.992672);
  final GoogleGeocoding googleGeocoding = GoogleGeocoding('AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc');
  @override
  void geocodingSearch(String value) async {
    var response = await googleGeocoding.geocoding.get(value, []);
    print(response?.results?[0].geometry?.location?.lng);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(""),
        ),
        drawer: HomeDrawer(),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: destination,
            zoom: 12.5,
            tilt: 68,
          ),
        ),
      ),
    );
  }
}
