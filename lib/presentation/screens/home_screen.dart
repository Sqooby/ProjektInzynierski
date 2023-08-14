import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/logic/models/autocomplete_prediction.dart';

import 'package:pv_analizer/logic/repositories/location_service.dart';
import 'package:pv_analizer/presentation/screens/map_screen.dart';

import 'package:pv_analizer/presentation/widgets/home_drawer.dart';
import 'package:pv_analizer/presentation/widgets/location_list_tile.dart';

import '../../logic/cubit/bus_stop_cubit.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  TextEditingController _destinationController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  @override
  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('marker'),
        position: point,
      ));
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Origin'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  var directions =
                      await LocationService().getDirections(_originController.text, _destinationController.text);

                  _goToPlace(directions['start_location']['lat'], directions['start_location']['lng']);
                  _setPolyline(directions['polyline_decoded']);
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          Expanded(
            child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                polygons: _polygons,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (point) {
                  setState(() {
                    polygonLatLngs.add(point);
                    _setPolygon();
                  });
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14),
      ),
    );
    _setMarker(LatLng(lat, lng));
  }
}
