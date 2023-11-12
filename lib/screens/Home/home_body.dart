import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/DataManager/data_manager.dart';
import 'package:pv_analizer/models/busStop.dart';
import 'package:pv_analizer/models/course_stage_list.dart';
import 'package:pv_analizer/repositories/location_service_repo.dart';
import 'package:geolocator/geolocator.dart';

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
          return Column(
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
                        IconButton(
                          onPressed: () async {
                            // final cos = widget.dm.busStopByCourseStages([74, 75, 76, 77, 78]);
                            // final cos1 = widget.dm.courseStagesByCourse([74, 75, 76, 77, 78]);
                            widget.orgDesBusStop = await gettingNearestBusStop(
                                widget.originLat, widget.originLng, widget.destinationLat, widget.destinationLng);
                            final courseMap = await gettingMapBusStopNameAndStage();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => MapBody(
                            //             courseStageMap: courseMap,
                            //           )),
                            // );
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
            ],
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

  Future<List<BusStop>> gettingNearestBusStop(double oriLat, double oriLng, double dstLat, double dstLng) async {
    double nearestDistanceToOrigin = 1000;
    double possibleNearestDistanceToOrigin;
    double nearestDistanceToDestination = 1000;
    double possibleNearestDistanceToDestination;

    double busStopLngOrg;
    double busStopLatOrg;
    double busStopLngDst;
    double busStopLatDst;
    BusStop? nearestOrgBusStop;
    BusStop? nearestDstBusStop;

    List<BusStop> BusStops = [];

    widget.busStopList.forEach((busStop) {
      busStopLatOrg = double.parse(busStop.gpsN);
      busStopLngOrg = double.parse(busStop.gpsE);
      busStopLatDst = double.parse(busStop.gpsN);
      busStopLngDst = double.parse(busStop.gpsE);

      possibleNearestDistanceToOrigin = Geolocator.distanceBetween(oriLng, oriLat, busStopLngOrg, busStopLatOrg).abs();
      possibleNearestDistanceToDestination =
          Geolocator.distanceBetween(dstLng, dstLat, busStopLngDst, busStopLatDst).abs();

      if (possibleNearestDistanceToOrigin < nearestDistanceToOrigin) {
        nearestDistanceToOrigin = possibleNearestDistanceToOrigin;
        nearestOrgBusStop = busStop;
      }
      if (possibleNearestDistanceToDestination < nearestDistanceToDestination) {
        nearestDistanceToDestination = possibleNearestDistanceToDestination;
        nearestDstBusStop = busStop;
      }
    });
    BusStops.add(nearestOrgBusStop!);
    BusStops.add(nearestDstBusStop!);

    return BusStops;
  }

  Future<Map<String, List<dynamic>>> gettingMapBusStopNameAndStage() async {
    final Map<String, List<dynamic>> courseMap = {};

    int firstIndex = -1;
    int lastIndex = -1;
    for (var i in [74, 75, 76, 77, 78]) {
      final List<Iterable<BusStop>> busStopbyId = await widget.dm.busStopByIdCourseStage(i);
      final List<CourseStageList> courseStageById = await widget.dm.courseStageByidCourse(i);
      List<dynamic> courseList = [];
      final Set<String> uniqueNames = {};
      for (var x = 0; x < busStopbyId.length; x++) {
        if (widget.orgDesBusStop[0].name == busStopbyId[x].first.name ||
            widget.orgDesBusStop[1].name == busStopbyId[x].first.name) {
          String name = busStopbyId[x].first.name;

          if (!uniqueNames.contains(name)) {
            if (firstIndex == -1) {
              // Store the index of the first occurrence of the name
              firstIndex = x;
            }
            // Store the index of the last occurrence of the name
            lastIndex = x;
            Map<String, dynamic> course = {
              'stage': courseStageById[x].stage.toString(),
              'name': name,
              'gps_n': busStopbyId[x].first.gpsN,
              'gps_e': busStopbyId[x].first.gpsE,
              'id_course': i
            };

            courseList.add(course);

            uniqueNames.add(name);
          }
        }
      }
      if (courseList.length == 1) {
        courseList = [];
      } else {
        courseMap['$i'] = courseList;
      }
    }

    return courseMap;
  }
}
