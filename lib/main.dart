import 'package:flutter/material.dart';
import 'package:pv_analizer/logic/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/logic/repositories/bus_stop_repo.dart';
import 'package:pv_analizer/presentation/screens/home_screen.dart';
import 'package:pv_analizer/presentation/screens/sing_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/logic/cubit/user_cubit.dart';
import 'package:pv_analizer/logic/models/user.dart';
import 'package:pv_analizer/logic/repositories/user_repo.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/map_screen.dart';

import 'presentation/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusStopCubit>(create: (context) => BusStopCubit(BusStopRepo())),
        BlocProvider<UserCubit>(create: (context) => UserCubit(UserRepo())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(24, 69, 186, 1),
          backgroundColor: Color.fromARGB(255, 26, 82, 224),
          fontFamily: "Lato",
        ),
        themeMode: ThemeMode.light,
        title: "Rzeszuf",
        home: LoginScreen(),
        initialRoute: '/',
        routes: {
          '/profile': (context) => ProfileScreen(),
          '/map': (context) => MapScreen(),
          '/sing_up': (context) => SingUpScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
