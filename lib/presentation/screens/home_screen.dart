import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/logic/models/autocomplete_prediction.dart';
import 'package:pv_analizer/logic/models/place_auto_complate_response.dart';
import 'package:pv_analizer/logic/repositories/netowrk_utillity.dart';

import 'package:pv_analizer/presentation/widgets/home_drawer.dart';
import 'package:pv_analizer/presentation/widgets/location_list_tile.dart';
import 'package:pv_analizer/presentation/widgets/login_wigdet.dart';

import '../../logic/cubit/bus_stop_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationLocationController = TextEditingController();
  List<AutocompletePrediction> currentLocationPredictions = [];
  List<AutocompletePrediction> destinationLocationPredictions = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // currentLocationController.text = currentLocation;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BusStopCubit>();

      cubit.fetchBusStop();
    });
  }

  void placeAutoComplete(String query, bool isCurrentLocation) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc',
        'language': 'pl',
      },
    );
    String? response = await NetworkUtility().fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          if (isCurrentLocation) {
            currentLocationPredictions = result.predictions!;
          } else {
            destinationLocationPredictions = result.predictions!;
          }
        });
      }
    }
  }

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
                          placeAutoComplete(value, true);
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
                      itemCount: currentLocationPredictions.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentLocationController.text = currentLocationPredictions[index].description!;

                              currentLocationPredictions = [];
                            });
                          },
                          child:
                              LocationListTile(location: currentLocationPredictions[index].description!, press: () {}),
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
                          placeAutoComplete(value, false);
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
                      itemCount: destinationLocationPredictions.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              destinationLocationController.text = destinationLocationPredictions[index].description!;

                              destinationLocationPredictions = [];
                            });
                          },
                          child: LocationListTile(
                              location: destinationLocationPredictions[index].description!, press: () {}),
                        );
                      }),
                    ),
                  ),

                  // LoginWidget(text: 'Dokąd jedziemy?', controlle: widget.mail),
                  // IconButton(
                  //   onPressed: () {
                  //     placeAutoComplete('Zimowit');
                  //     // setState(() {
                  //     //   context.read<BusStopCubit>().getCurrentPosition();
                  //     // });

                  //     // context.read<BusStopCubit>().fetchBusStop();
                  //     // print(state.busStop[0].name);
                  //   },
                  //   icon: Icon(Icons.abc),
                  // )
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
