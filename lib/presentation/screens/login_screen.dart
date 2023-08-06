import 'package:flutter/material.dart';
import 'package:pv_analizer/logic/cubit/user_cubit.dart';
import 'package:pv_analizer/logic/models/user.dart';
import 'package:pv_analizer/logic/repositories/user_repo.dart';
import 'package:pv_analizer/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/login_wigdet.dart';
import 'sing_up_screen.dart';
import 'map_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/';

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
      backgroundColor: Color.fromRGBO(226, 226, 226, 1),
      body: BlocBuilder<UserCubit, UserState>(
        builder: ((context, state) {
          if (state is UserErrorState) {
            print(state.error);
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
                            onPressed: () {
                              // context.read<UserCubit>().fetchUser();
                              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

                              // for (var x in state.users) {
                              //   if (x.email == mailController.text) {
                              //
                              //   }
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
                      style: ButtonStyle(),
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
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
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

    // SingleChildScrollView(
    //   child: Container(
    //     padding: EdgeInsets.only(top: 30),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(30),
    //           child: Text(
    //             'TransMazor',
    //             style: TextStyle(
    //               letterSpacing: 2,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 30,
    //               color: Theme.of(context).primaryColor,

    //               // fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //         Container(
    //           child: Image.asset(
    //             'assets/Icons/thunderbolt.png',
    //             color: Theme.of(context).primaryColor,
    //           ),
    //           height: 80,
    //         ),
    //         SizedBox(
    //           height: 30,
    //         ),
    //         Container(
    //           padding: EdgeInsets.all(10),
    //           child: Card(
    //             // color: Colors.white,
    //             child: BlocBuilder<UserCubit, UserState>(
    //               builder: (context, state) {
    //                 if (state is UserLoadingState || state is UserInitial) {
    //                   return CircularProgressIndicator();
    //                 } else if (state is UserLoadedState) {
    //                   final user = state.users;
    //                   return Column(
    //                     children: [
    //                       Column(
    //                         children: [
    //                           LoginWidget(
    //                             text: user.toString(),
    //                             controller: mail,
    //                           ),
    //                           LoginWidget(
    //                             text: "Hasło",
    //                             controller: password,
    //                           ),
    //                           SizedBox(
    //                             height: 5,
    //                           )
    //                         ],
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.all(20),
    //                         width: double.infinity,
    //                         color: Theme.of(context).primaryColor,
    //                         alignment: Alignment.center,
    //                         child: TextButton(
    //                           onPressed: () {
    //                             // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    //                             // context.read<UserCubit>().FetchUser();
    //                             // print(user.props);
    //                           },
    //                           child: Text(
    //                             "Zaloguj się",
    //                             style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   );
    //                 }
    //                 return Center(
    //                   child: Text(state.toString()),
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //         const Padding(
    //           padding: EdgeInsets.only(top: 8.0),
    //           child: SizedBox(
    //             height: 50,
    //             width: 80,
    //           ),
    //         ),
    //         const SizedBox(height: 15),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               "Nie masz konta?",
    //               style: TextStyle(
    //                 color: Theme.of(context).primaryColor,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pushNamed(SingUpScreen.routeName);
    //               },
    //               style: ButtonStyle(),
    //               child: Text(
    //                 "Załóż konto",
    //                 style: TextStyle(
    //                     color: Theme.of(context).primaryColor,
    //                     decoration: TextDecoration.underline,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         Container(
    //           margin: EdgeInsets.only(top: 50),
    //           child: Column(
    //             children: [],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  }
}
