import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pv_analizer/screens/Map/cubit/google_map_cubit.dart';
import 'package:pv_analizer/repositories/location_service_repo.dart';

import '../../widgets/home_drawer.dart';
import 'map_body.dart';

class MapScreen extends StatefulWidget {
  static String routeName = '/map';
  final String origin;
  final String destination;

  const MapScreen({required this.origin, required this.destination, Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return MapBody();
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       title: const Text(""),
    //     ),
    //     drawer: HomeDrawer(),
    //     body: BlocProvider(
    //       create: (context) => GoogleMapCubit(LocationService()),
    //       child: MapWidget(
    //         origin: widget.origin,
    //         destination: widget.destination,
    //       ),
    //     ),
    //   ),
    // );
  }
}
