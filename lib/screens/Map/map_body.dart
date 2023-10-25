import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/screens/Map/cubit/google_map_cubit.dart';
import 'package:pv_analizer/screens/BusStop/bus_stop_body.dart';
import 'package:pv_analizer/widgets/List_tile_of_course.dart';

class MapBody extends StatefulWidget {
  const MapBody({Key? key}) : super(key: key);

  @override
  State<MapBody> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapBody> {
  bool isLeftAligned = true;
  final String? key = dotenv.env['API_KEY'];
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  var _polylineIdCounter = 0;
  var _polygonIdCounter = 0;

  final List<LatLng> polygonLatLngs = <LatLng>[];
  List<LatLng> polylineCoordinates = [];
  static const LatLng sourceLocation = LatLng(50.018690000, 22.02623000);
  static const LatLng destination = LatLng(50.031660000, 22.03350000);
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      key!, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> goToPlace(double lat, double lng) async {
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 14),
        ),
      );
    }

    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(50.041187, 21.999121),
      zoom: 12.5,
    );
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
                  markers: {
                    const Marker(
                      markerId: MarkerId("source"),
                      position: sourceLocation,
                    ),
                    const Marker(
                      markerId: MarkerId("destination"),
                      position: destination,
                    ),
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylineCoordinates,
                        color: const Color(0xFF7B61FF),
                        width: 6),
                  },
                ),
                // ),
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
