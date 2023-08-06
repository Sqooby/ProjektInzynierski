import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/presentation/widgets/login_wigdet.dart';

import '../widgets/home_drawer.dart';

class MapScreen extends StatefulWidget {
  static String routeName = '/map';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const LatLng destination = LatLng(50.036266, 21.992672);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(""),
        ),
        drawer: HomeDrawer(),
        body: Stack(children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(target: destination, zoom: 12.5),
          ),
        ]),
      ),
    );
  }
}
