import 'package:flutter/material.dart';
import 'package:pv_analizer/DataManager/data_manager.dart';
import 'package:pv_analizer/models/busStop.dart';
import 'package:pv_analizer/repositories/location_service_repo.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final DataManager dt = DataManager();
  double originLat = 0;
  double originLng = 0;
  double destinationLat = 0;
  double destinationLng = 0;
  List<String> predictionsOriginList = [];
  List<String> predictionsDestinationList = [];
  List<BusStop> busStopList = [];
}

final LocationService ls = LocationService();

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        // widget.busStopList = state.busStop;
                      });
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

  Future listOfBusStopFun(int x) async {
    final courseStage = await widget.dt.busStopByIdCourseStage(74);

    return courseStage.first;
  }
}
