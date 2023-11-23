import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pv_analizer/screens/Login/cubit/user_cubit.dart';

import '../../widgets/home_drawer.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadedState) {
          var user = state.users[0];
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Profile"),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            drawer: HomeDrawer(),
            body: Center(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color.fromARGB(255, 5, 117, 216), blurRadius: 10, spreadRadius: 0.3),
                  ],
                ),
                margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Card(
                  shadowColor: const Color.fromARGB(255, 187, 187, 187),
                  elevation: 10,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "${user.firstName}" + " " + "${user.lastName}",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "${user.email}",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Zmień Login",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextButton(
                              style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                              onPressed: () {},
                              child: const Text(
                                "Zmień Hasło",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Przejazdy",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextButton(
                              style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                              onPressed: () {},
                              child: const Text(
                                "Płatności",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: RichText(
                      text: const TextSpan(
                        style:
                            TextStyle(fontSize: 14, color: Color.fromRGBO(24, 69, 186, 1), fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Mam problem z aplikacja -',
                          ),
                          TextSpan(
                            text: ' Support',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ), //<-- SEE HERE
                          ),
                        ],
                      ),
                    ))
                  ]),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
