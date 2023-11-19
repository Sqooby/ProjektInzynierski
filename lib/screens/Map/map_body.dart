import 'dart:math';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pv_analizer/widgets/List_tile_of_course.dart';

class MapBody extends StatefulWidget {
  final List<dynamic>? courseStageMap;

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
  List<LatLng> polylineCoordinates = [];
  Timer? timer;
  int currentIndex = 0;

  final Set<Marker> _markers = {};

  GoogleMapController? mapController;

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
        style: const TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawCircle(const Offset(30.0, 30.0), 30.0, paint);
    textPainter.paint(canvas, const Offset(20.0, 20.0));

    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  void getPolylineCoordinates() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey!,
        PointLatLng(
            double.parse(widget.courseStageMap!.first['gps_n']), double.parse(widget.courseStageMap!.first['gps_e'])),
        PointLatLng(
            double.parse(widget.courseStageMap!.last['gps_n']), double.parse(widget.courseStageMap!.last['gps_e'])));

    int markerInterval = 15;
    for (int i = 0; i < result.points.length; i++) {
      if (i % markerInterval == 0) {
        PointLatLng point = result.points[i];

        LatLng position = LatLng(point.latitude, point.longitude);
        polylineCoordinates.add(position);
        Marker marker = Marker(
          markerId: MarkerId('${point.latitude}_${point.longitude}'),
          position: position,
          infoWindow: InfoWindow(
            title: 'Marker',
            snippet: '${point.latitude}, ${point.longitude}',
          ),
        );

        _markers.add(marker);
      }
    }

    setState(() {});
  }

  void startMarkerMovement() {
    const duration = Duration(seconds: 30); // Update this based on how fast you want the marker to move
    timer = Timer.periodic(duration, (Timer t) {
      if (currentIndex < polylineCoordinates.length - 1) {
        int nextIndex = currentIndex + 1;
        LatLng startPosition = polylineCoordinates[currentIndex];
        LatLng endPosition = polylineCoordinates[nextIndex];
        List<LatLng> interpolatedPoints = interpolatePoints(startPosition, endPosition);
        animateMarker(interpolatedPoints, 0);
      } else {
        timer?.cancel(); // Stop the timer when we reach the end
      }
    });
  }

  List<LatLng> interpolatePoints(LatLng start, LatLng end) {
    // Determine the number of steps based on the duration and speed
    int steps = 6; // for example, 5 steps for a 500ms duration
    List<LatLng> points = [];

    for (int i = 0; i <= steps; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * (i / steps);
      double lng = start.longitude + (end.longitude - start.longitude) * (i / steps);
      points.add(LatLng(lat, lng));
    }

    return points;
  }

  void animateMarker(List<LatLng> points, int index) {
    if (index < points.length) {
      updateMarkerPosition(points[index]);
      Future.delayed(Duration(seconds: 5), () {
        animateMarker(points, index + 1);
      });
    } else {
      // Increment the current index when finished animating between the points
      currentIndex++;
    }
  }

  void updateMarkerPosition(LatLng newPosition) {
    Marker movingMarker = Marker(
        markerId: MarkerId('moving_dot'),
        position: newPosition, // New position
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Bus 123',
          snippet: 'Next stop: Central Station',
        ),
        zIndex: 2

        // You can customize the marker to be a red dot or any other icon
        );

    setState(() {
      // Update the position of the moving marker
      _markers.removeWhere((marker) => marker.markerId.value == 'moving_dot');
      _markers.add(movingMarker);
    });
    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newPosition, // The LatLng of the new position
      zoom: 14, // Adjust the zoom level as needed
    )));
  }

  @override
  void initState() {
    super.initState();
    getPolylineCoordinates();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      startMarkerMovement();
                    },
                    initialCameraPosition: kGooglePlex,
                    mapType: MapType.terrain,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylineCoordinates,
                        color: Colors.blue,
                        width: 3,
                      )
                    },
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
