import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  var _polylineIdCounter = 0;
  var _polygonIdCounter = 0;
  final Set<Marker> markers = Set<Marker>();
  final Set<Polygon> polygons = Set<Polygon>();
  final Set<Polyline> polylines = Set<Polyline>();
  final List<LatLng> polygonLatLngs = <LatLng>[];
  @override
  void initState() {
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

    void setPolyline(List<PointLatLng> points) {
      final String polylineIdVal = 'polyline$_polylineIdCounter';
      _polylineIdCounter++;
      polylines.add(
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

    void setMarker(LatLng point) {
      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ));
      });
    }

    void setPolygon() {
      final String polygonIdVal = 'polygon$_polygonIdCounter';
      _polygonIdCounter++;
      polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        strokeColor: Colors.transparent,
      ));
    }

    const CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(48.864716, 2.349014),
      zoom: 12.4746,
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
                // SizedBox(
                //   height: MediaQuery.sizeOf(context).height -
                //       AppBar().preferredSize.height -
                //       MediaQuery.sizeOf(context).height * 0.16,
                // child:
                GoogleMap(
                  initialCameraPosition: kGooglePlex,
                  mapType: MapType.terrain,
                  markers: markers,
                  polygons: polygons,
                  polylines: polylines,
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
                      )
                      // : Container(
                      //     width: MediaQuery.sizeOf(context).width * .5,
                      //     color: Colors.white,
                      //     child: const Column(
                      //       children: [
                      //         Card(
                      //           child: Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('godz'),
                      //           ),
                      //         ),
                      //         Divider(
                      //           thickness: 1,
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Icon(Icons.nordic_walking),
                      //         ),
                      //         Divider(thickness: 1),
                      //         Card(
                      //           margin: EdgeInsets.only(bottom: 10),
                      //           child: Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('godz'),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(Icons.bus_alert),
                      //               Card(
                      //                 child: Text('nr'),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         Card(
                      //           child: Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('kon'),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
//  Align(
//                           alignment: Alignment.centerRight,
//                           child: Container(
//                             width: MediaQuery.sizeOf(context).width * 0.25,
//                             color: Colors.white,
//                             child: const Column(
//                               children: [
//                                 Card(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text('godz'),
//                                   ),
//                                 ),
//                                 Divider(
//                                   thickness: 1,
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Icon(Icons.nordic_walking),
//                                 ),
//                                 Divider(thickness: 1),
//                                 Card(
//                                   margin: EdgeInsets.only(bottom: 10),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text('godz'),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.bus_alert),
//                                       Card(
//                                         child: Text('nr'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Card(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text('kon'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
