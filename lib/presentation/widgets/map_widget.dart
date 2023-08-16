import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/logic/cubit/google_map_cubit.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

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
          markerId: MarkerId('marker'),
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Google Maps'),
      ),
      body: BlocBuilder<GoogleMapCubit, GoogleMapState>(
        builder: (context, state) {
          if (state is GoogleMapInitial) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: originController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Origin'),
                            onChanged: (value) {},
                          ),
                          TextFormField(
                            controller: destinationController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Destination'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    var directions = await context.read<GoogleMapCubit>().fechtingDirection('Paris', 'Milan');

                    goToPlace(directions['start_location']['lat'], directions['start_location']['lng']);
                    setPolyline(directions['polyline_decoded']);
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            );
          }
          if (state is GoogleMapDirectionsFetched) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: originController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Origin'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                          TextFormField(
                            controller: destinationController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Destination'),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: kGooglePlex,
                      markers: markers,
                      polygons: polygons,
                      polylines: polylines,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onTap: (point) {
                        setState(() {
                          polygonLatLngs.add(point);
                          setMarker(LatLng(point.latitude, point.longitude));
                          print(point);
                        });
                      }),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
