import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/logic/cubit/google_map_cubit.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, required this.origin, required this.destination}) : super(key: key);
  final String origin;
  final String destination;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
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
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: GoogleMap(
            initialCameraPosition: kGooglePlex,
            mapType: MapType.normal,
            markers: markers,
            polygons: polygons,
            polylines: polylines,
          )),
          IconButton(
            onPressed: () async {
              var directions =
                  await context.read<GoogleMapCubit>().fechtingDirection(widget.origin, widget.destination);

              goToPlace(directions['start_location']['lat'], directions['start_location']['lng']);
              setPolyline(directions['polyline_decoded']);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
