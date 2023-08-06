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
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AutocompletePrediction> placePredictions = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BusStopCubit>();

      cubit.fetchBusStop();
    });
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': 'AIzaSyCPY2o9eEGZaaVVyt_X1O22Y_hrwkCzqrc',
        // 'language': 'pl',
        // 'location': '50.036266, 21.992672',
        // 'radius': '500',
        // 'types': 'street_address'
      },
    );
    String? response = await NetworkUtility().fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
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
                  // Text('LAT: ${context.read<BusStopCubit>().currentPosition?.latitude ?? ""}'),
                  // Text('LNG: ${context.read<BusStopCubit>().currentPosition?.longitude ?? ""}'),
                  // Text('ADDRESS: ${context.read<BusStopCubit>().currentAddress ?? ""}'),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        onChanged: (value) {
                          placeAutoComplete(value);
                        },
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(hintText: 'Twoja lokalizacja'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placePredictions.length,
                      itemBuilder: ((context, index) {
                        return LocationListTile(
                          location: placePredictions[index].description!,
                          press: () {},
                        );
                      }),
                    ),
                  ),

                  // LoginWidget(text: 'Dokąd jedziemy?', controller: widget.mail),
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
