import 'package:flutter/material.dart';

import 'package:pv_analizer/screens/Login/cubit/user_cubit.dart';

import 'package:pv_analizer/screens/Home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/login_wigdet.dart';
import '../SingUp/sing_up_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<UserCubit>();
      cubit.fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 226, 226, 1),
      body: BlocBuilder<UserCubit, UserState>(
        builder: ((context, state) {
          print(state);
          if (state is UserErrorState) {
          } else if (state is UserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'TransMazor',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,

                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    'assets/Icons/thunderbolt.png',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    // color: Colors.white,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            LoginWidget(
                              text: "mail",
                              controller: mailController,
                            ),
                            LoginWidget(
                              text: "Hasło",
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                              // final busStopByCourse = await DataManager().busStopByIdCourseStage(75);
                              // for (var x in busStopByCourse) {
                              //   print(x.first.name);
                              // }
                            },
                            child: const Text(
                              "Zaloguj się",
                              style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 50,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nie masz konta?",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SingUpScreen.routeName);
                      },
                      style: const ButtonStyle(),
                      child: Text(
                        "Załóż konto",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Column(
                    children: [],
                  ),
                ),
              ],
            );
          } else if (state is UserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
