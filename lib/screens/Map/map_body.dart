import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/models/busStop.dart';

import 'package:pv_analizer/widgets/List_tile_of_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBody extends StatefulWidget {
  final List<dynamic>? courseStageMap;
  final VoidCallback onButtonPressed;
  final TimeOfDay startedTime;

  const MapBody({
    Key? key,
    required this.courseStageMap,
    required this.onButtonPressed,
    required this.startedTime,
  }) : super(key: key);

  @override
  State<MapBody> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapBody> {
  List<BusStop> busStops = [];
  bool isLeftAligned = true;
  final String? apiKey = dotenv.env['API_KEY'];
  List<LatLng> polylineCoordinates = [];
  Timer? timer;
  int currentIndex = 0;
  TimeOfDay? startedTime;

  final Set<Marker> _markers = {};

  GoogleMapController? mapController;

  final List<LatLng> polygonLatLngs = <LatLng>[];

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(50.041187, 21.999121),
    zoom: 12.5,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusStopCubit, BusStopState>(
      builder: (context, state) {
        if (state is BusStopLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BusStopErrorState) {
        } else if (state is BusStopLoadedState) {
          busStops = state.busStop;

          @override
          double calculateDistance(lat1, lon1, lat2, lon2) {
            var p = 0.017453292519943295;
            var c = cos;
            var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
            return 12742 * asin(sqrt(a));
          }

          void getPolylineCoordinates() async {
            PolylinePoints polylinePoints = PolylinePoints();

            PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
              apiKey!,
              PointLatLng(double.parse(widget.courseStageMap!.first['gps_n']),
                  double.parse(widget.courseStageMap!.first['gps_e'])),
              PointLatLng(
                double.parse(widget.courseStageMap!.last['gps_n']),
                double.parse(widget.courseStageMap!.last['gps_e']),
              ),
            );

            const double radius = 0.05; // radius in kilometers
            for (var busStop in busStops) {
              for (var point in result.points) {
                LatLng position = LatLng(point.latitude, point.longitude);

                double distance = calculateDistance(
                    double.parse(busStop.gpsN), double.parse(busStop.gpsE), point.latitude, point.longitude);

                if (distance <= radius) {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(busStop.name),
                      position: LatLng(double.parse(busStop.gpsN), double.parse(busStop.gpsE)),
                      infoWindow: InfoWindow(title: busStop.name),
                    ),
                  );
                  break; // Stop checking other points if one is within the radius
                }
                if (!polylineCoordinates.contains(position)) {
                  polylineCoordinates.add(position);
                }
              }

              setState(() {});
            }
          }

          List<LatLng> interpolatePoints(LatLng start, LatLng end) {
            // Determine the number of steps based on the duration and speed

            List<LatLng> points = [];
            int steps = 5;

            for (int i = 0; i <= steps; i++) {
              double lat = start.latitude + (end.latitude - start.latitude) * (i / steps);
              double lng = start.longitude + (end.longitude - start.longitude) * (i / steps);
              points.add(LatLng(lat, lng));
            }

            return points;
          }

          void updateMarkerPosition(LatLng newPosition) {
            Marker movingMarker = Marker(
                markerId: const MarkerId('moving_dot'),
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

          void animateMarker(List<LatLng> points, int index) {
            if (index < points.length) {
              updateMarkerPosition(points[index]);
              Future.delayed(const Duration(seconds: 1), () {
                animateMarker(points, index + 1);
              });
            } else {
              // Increment the current index when finished animating between the points
              currentIndex++;
            }
          }

          void startMarkerMovement() {
            const duration = Duration(seconds: 10); // Update this based on how fast you want the marker to move
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

          @override
          @override
          void dispose() {
            timer?.cancel();
            super.dispose();
          }

          void showCustomBottomSheet() {
            showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 64,
                  color: Colors.black12,
                  child: const Center(
                    child: Text(
                      "Złe dane!!!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );

            // Close the bottom sheet after 2 seconds
            Timer(const Duration(seconds: 2), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }

          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                ListTileOfCourse(startedTime: widget.startedTime),
                ElevatedButton(
                  onPressed: () {
                    widget.onButtonPressed();
                    Navigator.pop(context);
                  },
                  child: const Text('Sledz przejazd'),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height -
                      AppBar().preferredSize.height -
                      MediaQuery.sizeOf(context).height * 0.16,
                  child: Stack(
                    children: [
                      GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            getPolylineCoordinates();
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
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
