import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/DataManager/data_manager.dart';
import 'package:pv_analizer/models/busStop.dart';
import 'package:pv_analizer/models/course_stage_list.dart';
import 'package:pv_analizer/repositories/location_service_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pv_analizer/screens/BusStop/bus_stop_screen.dart';
import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
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
                            widget.orgDesBusStop = await gettingNearestBusStop(
                                widget.originLat, widget.originLng, widget.destinationLat, widget.destinationLng);
                            final courseMap = await gettingMapBusStopNameAndStage();
                            print(courseMap);
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

  Future<List> gettingMapBusStopNameAndStage() async {
    final List<Iterable<BusStop>> course74Bus = await widget.dm.busStopByIdCourseStage(74);
    final List<CourseStageList> course_74 = await widget.dm.courseStageByidCourse(74);
    final List courseMap = [];
    Set<String> uniqueNames = {};

    for (var i = 0; i < course_74.length; i++) {
      if (widget.orgDesBusStop[0].name == course74Bus[i].first.name ||
          widget.orgDesBusStop[1].name == course74Bus[i].first.name) {
        String name = course74Bus[i].first.name;
        if (!uniqueNames.contains(name)) {
          Map<String, dynamic> course = {
            'stage': course_74[i].stage.toString(),
            'name': name,
          };
          courseMap.add(course);
          uniqueNames.add(name);
        } else {
          // If the name is already in the Set, update the 'stage' property if needed
          for (var existingCourse in courseMap) {
            if (existingCourse['name'] == name) {
              break;
            }
          }
        }
      }
    }
    return courseMap;
  }
}
