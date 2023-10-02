import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/screens/Home/home_body.dart';

import 'package:pv_analizer/screens/Map/cubit/google_map_cubit.dart';

import 'package:pv_analizer/models/busStop.dart';
import 'package:pv_analizer/widgets/list_of_predictions_location.dart';

import '../../repositories/bus_stop_time_repo.dart';

import 'package:pv_analizer/repositories/location_service_repo.dart';
import '../../widgets/home_drawer.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(),
      body: HomeWidget(),
    );
  }
}
