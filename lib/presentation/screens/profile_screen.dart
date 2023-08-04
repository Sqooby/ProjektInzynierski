import 'package:flutter/material.dart';

import '../widgets/home_drawer.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/Images/woman.jpg'),
                      maxRadius: 50,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: AssetImage("assets/Images/pencil.png"),
                              color: Colors.white,
                            ),
                            Text(
                              "Edytuj Profil",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Zmień Login",
                      style:
                          TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
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
                      style:
                          TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
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
                  style: TextStyle(fontSize: 14, color: Color.fromRGBO(24, 69, 186, 1), fontWeight: FontWeight.bold),
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
}
