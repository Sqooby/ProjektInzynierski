import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pv_analizer/logic/cubit/bus_stop_cubit.dart';

import 'package:pv_analizer/logic/cubit/google_map_cubit.dart';

import 'package:pv_analizer/logic/models/busStop.dart';

import '/../logic/repositories/bus_stop_time_repo.dart';

import 'package:pv_analizer/logic/repositories/location_service_repo.dart';
import '../widgets/home_drawer.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<String> predictionsOriginList = [];
  List<String> predictionsDestinationList = [];
  List<BusStop> busStopList = [];
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BusStopCubit>();
      cubit.fetchBusStop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final LocationService ls = LocationService();

    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(),
      body: BlocBuilder<GoogleMapCubit, GoogleMapState>(
        builder: (context, state) {
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
                          onPressed: () {
                            setState(() {
                              // widget.busStopList = state.busStop;
                            });
                            BusStopTimeRepo().getBusStopTime();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => MapScreen(
                            //       origin: widget.originController.text,
                            //       destination: widget.destinationController.text,
                            //     ),
                            //   ),
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
              widget.predictionsOriginList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: widget.predictionsOriginList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              widget.originController.text = widget.predictionsOriginList[index];

                              final place = await ls.getPlace(widget.originController.text);
                              final originLat = place['geometry']['location']['lat'];
                              final originLng = place['geometry']['location']['lng'];

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
                    )
                  : const SizedBox(),
              widget.predictionsDestinationList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: widget.predictionsDestinationList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              widget.destinationController.text = widget.predictionsDestinationList[index];
                              final place = await ls.getPlace(widget.destinationController.text);
                              final destinationLat = place['geometry']['location']['lat'];
                              final destinationLng = place['geometry']['location']['lng'];

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
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
