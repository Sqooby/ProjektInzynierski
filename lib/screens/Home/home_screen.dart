import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/screens/Home/home_body.dart';




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
