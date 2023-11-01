// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pv_analizer/widgets/List_tile_of_course.dart';

class MapBody extends StatefulWidget {
  const MapBody({
    Key? key,
  }) : super(key: key);

  @override
  State<MapBody> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapBody> {
  bool isLeftAligned = true;
  final String? apiKey = dotenv.env['API_KEY'];

  Set<Marker> markers = {};

  GoogleMapController? mapController;
  final Set<Polyline> _polylines = {};

  List<LatLng> listLocations = [
    const LatLng(50.018690000, 22.026230000),
    const LatLng(50.031660000, 22.033500000),
    const LatLng(50.034520000, 22.033430000),
    const LatLng(50.022710000, 21.982480000),
    const LatLng(50.023290000, 21.980970000),
  ];

  final List<LatLng> polygonLatLngs = <LatLng>[];

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(50.041187, 21.999121),
    zoom: 12.5,
  );

  Future<List<LatLng>> getPolylineCoordinates() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = [];

    for (var i = 0; i < listLocations.length - 1; i++) {
      PointLatLng currentLocation = PointLatLng(listLocations[i].latitude, listLocations[i].longitude);
      PointLatLng nextLocation = PointLatLng(listLocations[i + 1].latitude, listLocations[i + 1].longitude);
      ;

      PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
        apiKey!,
        currentLocation,
        nextLocation,
      );

      if (polylineResult.points.isNotEmpty) {
        result.addAll(polylineResult.points);

        setState(() {});
      }
    }

    return result.map((point) => LatLng(point.latitude, point.longitude)).toList();
  }

  void _drawPolyline() async {
    List<LatLng> polylineCoordinates = await getPolylineCoordinates();

    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 6,
        points: polylineCoordinates,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const ListTileOfCourse(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height -
                AppBar().preferredSize.height -
                MediaQuery.sizeOf(context).height * 0.16,
            child: Stack(
              children: [
                GoogleMap(
                    initialCameraPosition: kGooglePlex,
                    mapType: MapType.terrain,
                    onMapCreated: (GoogleMapController controller) {
                      _drawPolyline();
                    },
                    polylines: _polylines,
                    markers: {
                      Marker(
                        markerId: const MarkerId('origin'),
                        position: LatLng(
                          listLocations.first.latitude,
                          listLocations.first.longitude,
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId('destination'),
                        position: LatLng(
                          listLocations.last.latitude,
                          listLocations.last.longitude,
                        ),
                      ),
                    }),
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      setState(() {
                        isLeftAligned = true;
                      });
                    } else if (details.primaryVelocity! < 0) {
                      setState(() {
                        isLeftAligned = false;
                      });
                    }
                  },
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isLeftAligned
                            ? MediaQuery.sizeOf(context).width * 0.25
                            : MediaQuery.sizeOf(context).width * 0.7,
                        color: Colors.white,
                        child: const Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('godz'),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.nordic_walking),
                            ),
                            Divider(thickness: 1),
                            Card(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('godz'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bus_alert),
                                  Card(
                                    child: Text('nr'),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('kon'),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
