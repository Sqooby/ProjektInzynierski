import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/logic/models/autocomplete_prediction.dart';
import 'package:pv_analizer/logic/models/place_auto_complate_response.dart';
import 'package:pv_analizer/logic/repositories/network_utility.dart';
import 'package:pv_analizer/presentation/screens/map_screen.dart';

import 'package:pv_analizer/presentation/widgets/home_drawer.dart';
import 'package:pv_analizer/presentation/widgets/location_list_tile.dart';

import '../../logic/cubit/bus_stop_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkUtility nt = NetworkUtility();
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationLocationController = TextEditingController();
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
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(""),
      ),
      body: BlocBuilder<BusStopCubit, BusStopState>(
        builder: (context, state) {
          if (state is BusStopErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is BusStopLoadedState) {
            return Center(
              child: Column(
                children: [
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: currentLocationController,
                        onChanged: (value) {
                          setState(() {
                            nt.placeAutoComplete(value, true);
                          });

                          print(nt.destinationLocationPredictions[0]);
                        },
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(hintText: 'Enter Location'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nt.currentLocationPredictions.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentLocationController.text = nt.currentLocationPredictions[index].description!;
                              print(nt.currentLocationPredictions[index].description!);

                              nt.currentLocationPredictions = [];
                            });
                          },
                          child: LocationListTile(
                              location: nt.currentLocationPredictions[index].description!, press: () {}),
                        );
                      }),
                    ),
                  ),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: destinationLocationController,
                        onChanged: (value) {
                          setState(() {
                            nt.placeAutoComplete(value, false);
                          });
                        },
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(hintText: 'Gdzie jedziemy?'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nt.destinationLocationPredictions.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              destinationLocationController.text =
                                  nt.destinationLocationPredictions[index].description!;

                              nt.destinationLocationPredictions = [];
                            });
                          },
                          child: LocationListTile(
                              location: nt.destinationLocationPredictions[index].description!, press: () {}),
                        );
                      }),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
                    },
                    icon: const Icon(Icons.abc_sharp),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
