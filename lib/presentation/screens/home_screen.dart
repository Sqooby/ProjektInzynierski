import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pv_analizer/presentation/widgets/home_drawer.dart';
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
              child: Center(
                child: Column(
                  children: [
                    Text('LAT: ${context.read<BusStopCubit>().currentPosition?.latitude ?? ""}'),
                    Text('LNG: ${context.read<BusStopCubit>().currentPosition?.longitude ?? ""}'),
                    Text('ADDRESS: ${context.read<BusStopCubit>().currentAddress ?? ""}'),
                    // LoginWidget(text: 'Twoja Lokalizacja', controller: widget.mail),
                    const SizedBox(
                      height: 30,
                    ),
                    // LoginWidget(text: 'Dokąd jedziemy?', controller: widget.mail),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          context.read<BusStopCubit>().getCurrentPosition();
                        });

                        // context.read<BusStopCubit>().fetchBusStop();
                        // print(state.busStop[0].name);
                      },
                      icon: Icon(Icons.abc),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
