import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pv_analizer/logic/cubit/bus_stop_cubit.dart';
import 'package:pv_analizer/logic/cubit/google_map_cubit.dart';
import 'package:pv_analizer/logic/repositories/bus_stop_repo.dart';

import 'package:pv_analizer/logic/repositories/location_service_repo.dart';
import 'package:pv_analizer/presentation/screens/home_screen.dart';
import 'package:pv_analizer/presentation/screens/sing_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/logic/cubit/user_cubit.dart';

import 'package:pv_analizer/logic/repositories/user_repo.dart';

import 'presentation/screens/login_screen.dart';

import 'presentation/screens/profile_screen.dart';

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
        BlocProvider<GoogleMapCubit>(
          create: (context) => GoogleMapCubit(LocationService()),
        ),
        BlocProvider<BusStopCubit>(create: (context) => BusStopCubit(BusStopRepo())),
        BlocProvider<UserCubit>(create: (context) => UserCubit(UserRepo())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(24, 69, 186, 1),
          backgroundColor: const Color.fromARGB(255, 26, 82, 224),
          fontFamily: "Lato",
        ),
        themeMode: ThemeMode.light,
        home: const LoginScreen(),
        initialRoute: '/',
        routes: {
          '/profile': (context) => const ProfileScreen(),
          '/sing_up': (context) => SingUpScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
