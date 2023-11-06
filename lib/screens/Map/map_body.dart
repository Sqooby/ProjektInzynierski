// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pv_analizer/widgets/List_tile_of_course.dart';

class MapBody extends StatefulWidget {
  final List<dynamic> courseStageMap;
  const MapBody({
    Key? key,
    required this.courseStageMap,
  }) : super(key: key);

  @override
  State<MapBody> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapBody> {
  bool isLeftAligned = true;
  final String? apiKey = dotenv.env['API_KEY'];

  final Set<Marker> _markers = {};

  GoogleMapController? mapController;
  final Set<Polyline> _polylines = {};

  final List<LatLng> polygonLatLngs = <LatLng>[];

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(50.041187, 21.999121),
    zoom: 12.5,
  );
  Future<Uint8List> getMarkerIcon(int number) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: number.toString(),
        style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawCircle(Offset(30.0, 30.0), 30.0, paint);
    textPainter.paint(canvas, Offset(20.0, 20.0));

    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<List<LatLng>> getPolylineCoordinates() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = [];

    for (var i = 0; i < widget.courseStageMap.length - 1; i++) {
      PointLatLng currentLocation =
          PointLatLng(double.parse(widget.courseStageMap[i]['gps_n']), double.parse(widget.courseStageMap[i]['gps_e']));
      PointLatLng nextLocation = PointLatLng(
          double.parse(widget.courseStageMap[i + 1]['gps_n']), double.parse(widget.courseStageMap[i + 1]['gps_e']));
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

  Future<Set<Marker>> getMarkerCoordinates() async {
    Set<Marker> markers = {};
    for (var i = 0; i < widget.courseStageMap.length; i++) {
      double gpsN = double.parse(widget.courseStageMap[i]['gps_n']);
      double gpsE = double.parse(widget.courseStageMap[i]['gps_e']);
      Uint8List markerIcon = await getMarkerIcon(i + 1);
      String markerId = 'marker_$i';

      Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId(markerId),
        position: LatLng(gpsN, gpsE),
      );

      markers.add(marker);
    }
    return markers;
  }

  void _drawPolyline() async {
    List<LatLng> polylineCoordinates = await getPolylineCoordinates();
    Set<Marker> markers = await getMarkerCoordinates();

    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 6,
        points: polylineCoordinates,
      ));
      _markers.addAll(markers);
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
                    markers: _markers),
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
