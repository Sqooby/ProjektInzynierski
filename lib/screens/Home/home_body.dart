import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pv_analizer/DataManager/data_manager.dart';
import 'package:pv_analizer/models/busStop.dart';

import 'package:pv_analizer/repositories/location_service_repo.dart';

import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/screens/Map/map_body.dart';

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
  static String routeName = '/home';
  HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final DataManager dm = DataManager();
  double originLat = 0;
  double originLng = 0;
  double destinationLat = 0;
  double destinationLng = 0;
  List<String> predictionsOriginList = [];
  List<String> predictionsDestinationList = [];
  List<BusStop> busStopList = [];
  List<BusStop> orgDesBusStop = [];
  List<Map<String, dynamic>> activeRoutes = [];
  TimeOfDay selectedTime = TimeOfDay.now();
}

final LocationService ls = LocationService();

class _HomeWidgetState extends State<HomeWidget> {
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
          widget.busStopList = state.busStop;
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: widget.originController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Origin'),
                            onChanged: (value) async {
                              final result = await ls.getAutocompleteLocation(value);

                              setState(() {
                                widget.predictionsOriginList = result;
                              });
                            },
                          ),
                          TextFormField(
                            controller: widget.destinationController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(hintText: 'Destination'),
                            onChanged: (value) async {
                              var result = await ls.getAutocompleteLocation(value);

                              setState(() {
                                widget.predictionsDestinationList = result;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${widget.selectedTime.hour}:${widget.selectedTime.minute}'),
                              ElevatedButton(
                                child: const Text('Choose Time'),
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay = await showTimePicker(
                                      context: context,
                                      initialTime: widget.selectedTime,
                                      initialEntryMode: TimePickerEntryMode.dial);
                                  if (timeOfDay != null) {
                                    setState(() {
                                      widget.selectedTime = timeOfDay;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              final origin = widget.originController.text;
                              final destination = widget.destinationController.text;
                              final coordinates = await ls.getDirections(origin, destination);

                              final startLocation = coordinates['start_location'];
                              final endLocation = coordinates['end_location'];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapBody(
                                    startedTime: widget.selectedTime,
                                    startLocation: LatLng(startLocation['lat'], startLocation['lng']),
                                    endLocation: LatLng(endLocation['lat'], endLocation['lng']),
                                    polylinePoints: PolylinePoints().decodePolyline(coordinates['polyline'] as String),
                                    onButtonPressed: () {
                                      var newRoute = {
                                        'origin': widget.originController.text,
                                        'destination': widget.destinationController.text,
                                        'time': widget.selectedTime.format(context) // format TimeOfDay to String
                                      };
                                      bool existingRoute = widget.activeRoutes.any((route) =>
                                          route['origin'] == newRoute['origin'] &&
                                          route['destination'] == newRoute['destination'] &&
                                          route['time'] == newRoute['time']);

                                      if (!existingRoute) {
                                        setState(() {
                                          widget.activeRoutes.add(newRoute);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.search,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                widget.predictionsOriginList.isNotEmpty ? originLocationListView() : const SizedBox(),
                widget.predictionsDestinationList.isNotEmpty ? destinationLocationListView() : const SizedBox(),
                widget.activeRoutes.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: widget.activeRoutes.length,
                          itemBuilder: (context, index) {
                            final route = widget.activeRoutes[index];
                            final key = '${route['origin']}-${route['destination']}-${route['time']}';
                            return Dismissible(
                              key: Key(key),
                              onDismissed: (direction) {
                                setState(() {
                                  widget.activeRoutes.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${route['origin']} to ${route['destination']} at ${route['time']}   dismissed')));
                              },
                              background: Container(color: Colors.red),
                              child: GestureDetector(
                                onTap: () async {
                                  final origin = widget.originController.text;
                                  final destination = widget.destinationController.text;
                                  final coordinates = await ls.getDirections(origin, destination);

                                  final startLocation = coordinates['start_location'];
                                  final endLocation = coordinates['end_location'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapBody(
                                          startedTime: widget.selectedTime,
                                          startLocation: LatLng(startLocation['lat'], startLocation['lng']),
                                          endLocation: LatLng(endLocation['lat'], endLocation['lng']),
                                          polylinePoints:
                                              PolylinePoints().decodePolyline(coordinates['polyline'] as String),
                                          onButtonPressed: () {}),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 80,
                                  child: ListTile(
                                    leading: Text(route['origin']),
                                    title: Text(route['destination']),
                                    trailing: Text(route['time']),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget originLocationListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.predictionsOriginList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              widget.originController.text = widget.predictionsOriginList[index];

              final place = await ls.getPlace(widget.originController.text);

              widget.originLat = place['geometry']['location']['lat'];
              widget.originLng = place['geometry']['location']['lng'];

              setState(() {
                widget.predictionsOriginList = [];
              });
            },
            child: ListTile(
              title: Text(
                widget.predictionsOriginList[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget destinationLocationListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.predictionsDestinationList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              widget.destinationController.text = widget.predictionsDestinationList[index];
              final place = await ls.getPlace(widget.destinationController.text);
              widget.destinationLat = place['geometry']['location']['lat'];
              widget.destinationLng = place['geometry']['location']['lng'];

              setState(() {
                widget.predictionsDestinationList = [];
              });
            },
            child: ListTile(
              title: Text(
                widget.predictionsDestinationList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
