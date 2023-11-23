import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pv_analizer/screens/Login/cubit/user_cubit.dart';

import 'package:pv_analizer/screens/Home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<UserCubit>();
      cubit.fetchUser();
    });
  }

  addIdToSf(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 226, 226, 1),
      body: BlocBuilder<UserCubit, UserState>(
        builder: ((context, state) {
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
                  padding: const EdgeInsets.all(27),
                  child: Text(
                    'TransMazor',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
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
                    child: Column(
                      children: [
                        Column(
                          children: [
                            LoginWidget(
                              textInputType: TextInputType.emailAddress,
                              text: "mail",
                              controller: mailController,
                            ),
                            LoginWidget(
                              text: "Hasło",
                              controller: passwordController,
                              textInputType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () async {
                              bool result = false;
                              for (var x in state.users) {
                                if (x.email == mailController.text && x.password == passwordController.text) {
                                  result = true;

                                  addIdToSf(x.idUser);
                                }
                              }

                              if (result) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              } else {
                                showBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 64,
                                      color: Colors.black12,
                                      child: Center(
                                          child: !result
                                              ? const Text(
                                                  "Złe dane!!!",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : const Text('')),
                                    );
                                  },
                                );
                                Timer(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                              }
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
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
