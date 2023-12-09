import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/repositories/location_service_repo.dart';
import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/models/busStop.dart';

import 'package:pv_analizer/widgets/List_tile_of_course.dart';

class MapBody extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final List<PointLatLng> polylinePoints;

  final VoidCallback onButtonPressed;
  final TimeOfDay startedTime;

  const MapBody({
    Key? key,
    required this.onButtonPressed,
    required this.startedTime,
    required this.startLocation,
    required this.endLocation,
    required this.polylinePoints,
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
  Set<Polyline> _polylines = Set<Polyline>();
  LocationService ls = LocationService();

  Set<Marker> _markers = {};
  final List<Marker> markersCoordinates = [];

  late GoogleMapController mapController;

  final List<LatLng> polygonLatLngs = <LatLng>[];

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(50.041187, 21.999121),
    zoom: 12.5,
  );
  bool isTimeToStart(TimeOfDay targetTime) {
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    return targetTime.hour == currentTime.hour && targetTime.minute == currentTime.minute;
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (isTimeToStart(widget.startedTime)) {
        animateCamera();
        t.cancel(); // Cancel the timer as it's no longer needed
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
                  child: const Text('Book a ride'),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height -
                      AppBar().preferredSize.height -
                      MediaQuery.sizeOf(context).height * 0.16,
                  child: Stack(
                    children: [
                      GoogleMap(
                          onMapCreated: onMapCreated,
                          initialCameraPosition: kGooglePlex,
                          mapType: MapType.terrain,
                          polylines: _polylines,
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

  List<LatLng> interpolate(LatLng start, LatLng end, int steps) {
    List<LatLng> path = [];
    for (int i = 0; i <= steps; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * i / steps;
      double lng = start.longitude + (end.longitude - start.longitude) * i / steps;
      path.add(LatLng(lat, lng));
    }
    return path;
  }

  Future<void> animateCamera() async {
    for (int i = 0; i < widget.polylinePoints.length; i++) {
      LatLng startMarker = LatLng(widget.polylinePoints[i].latitude, widget.polylinePoints[i].longitude);
      LatLng endMarker = LatLng(widget.polylinePoints[i + 1].latitude, widget.polylinePoints[i + 1].longitude);
      List<LatLng> path = interpolate(startMarker, endMarker, 10);

      for (LatLng point in path) {
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: 15),
          ),
        );
        setState(() {
          Marker updatedMarker = Marker(
            markerId: const MarkerId('camera_position'),
            position: point,
            infoWindow: InfoWindow(title: '$point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
          _markers.removeWhere((m) => m.markerId.value == 'camera_position');
          _markers.add(updatedMarker);
        });
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: widget.startLocation,
      infoWindow: const InfoWindow(title: 'Start Location'),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: widget.endLocation,
      infoWindow: const InfoWindow(title: 'Destination Location'),
    );

    polylineCoordinates = widget.polylinePoints.map((point) => LatLng(point.latitude, point.longitude)).toList();
    final routePolyline = Polyline(
      polylineId: const PolylineId('route'),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    );
    markersCoordinates.clear();
    markersCoordinates.add(startMarker);
    for (var busStop in busStops) {
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        double distance =
            calculateDistance(LatLng(double.parse(busStop.gpsN), double.parse(busStop.gpsE)), polylineCoordinates[i]);

        if (distance <= 0.03) {
          // Dodaj marker przystanku
          markersCoordinates.add(Marker(
            markerId: MarkerId('busStop_${busStop.idBusStop}'),
            position: LatLng(double.parse(busStop.gpsN), double.parse(busStop.gpsE)),
            infoWindow: InfoWindow(title: busStop.name),
          ));

          break; // Przerwij pętlę, jeśli znaleziono przystanek w pobliżu
        }
      }
    }
    markersCoordinates.add(endMarker);
    _markers = markersCoordinates.toSet();

    _polylines.add(routePolyline);

    setState(() {
      // Dodaj markery do mapy
    });
  }

  double calculateDistance(LatLng start, LatLng end) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) * cos(end.latitude * p) * (1 - cos((end.longitude - start.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
