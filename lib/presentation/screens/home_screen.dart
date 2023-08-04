import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/logic/models/busStop.dart';
import 'package:pv_analizer/presentation/widgets/home_drawer.dart';
import 'package:pv_analizer/presentation/widgets/login_wigdet.dart';
import 'package:geolocator/geolocator.dart';

import '../../logic/cubit/bus_stop_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Future<Position> _getCurrentPosistion() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   double latitude = position.latitude;
  //   double longitude = position.longitude;
  //   print(latitude);
  //   print(longitude);
  //   return position;
  // }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // void _handleCurrentPosiostion() {
  //   widget._getCurrentPosistion();
  // }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<BusStopCubit>();

      cubit.fetchBusStop();
    });
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  LoginWidget(text: 'Twoja Lokalizacja', controller: widget.mail),
                  const SizedBox(
                    height: 30,
                  ),
                  LoginWidget(text: 'Dokąd jedziemy?', controller: widget.mail),
                  IconButton(
                    onPressed: () {
                      context.read<BusStopCubit>().fetchBusStop();
                      print(state.busStop[0].name);
                    },
                    icon: Icon(Icons.abc),
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
