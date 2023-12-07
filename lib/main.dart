import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pv_analizer/screens/AboutMe/about_me_screen.dart';

import 'package:pv_analizer/screens/BusStop/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/screens/Login/login_screen.dart';
import 'package:pv_analizer/screens/Map/cubit/google_map_cubit.dart';
import 'package:pv_analizer/repositories/bus_stop_repo.dart';

import 'package:pv_analizer/repositories/location_service_repo.dart';
import 'package:pv_analizer/screens/Home/home_screen.dart';

import 'package:pv_analizer/screens/SingUp/sing_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/screens/Login/cubit/user_cubit.dart';

import 'package:pv_analizer/repositories/user_repo.dart';

import 'screens/profile/profile_screen.dart';

void main() async {
  await dotenv.load(fileName: 'lib/constant.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GoogleMapCubit>(create: (context) => GoogleMapCubit(LocationService())),
        BlocProvider<BusStopCubit>(create: (context) => BusStopCubit(BusStopRepo())),
        BlocProvider<UserCubit>(create: (context) => UserCubit(UserRepo())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(24, 69, 186, 1),
          fontFamily: "Lato",
        ),
        themeMode: ThemeMode.light,
        home: const LoginScreen(),
        initialRoute: '/',
        routes: {
          '/profile': (context) => ProfileScreen(),
          '/sing_up': (context) => SingUpScreen(),
          '/home': (context) => HomeScreen(),
          '/about_me': (context) => AboutMeScreen(),
        },
      ),
    );
  }
}
