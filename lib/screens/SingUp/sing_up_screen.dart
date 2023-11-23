import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';

import '../Login/cubit/user_cubit.dart';

import '../../widgets/login_wigdet.dart';

class SingUpScreen extends StatefulWidget {
  static String routeName = '/sing_up';
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController homeAddress = TextEditingController();

  SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  bool checkedValue = false;
  final _formKey = GlobalKey<FormState>();
  String role = 'client';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserErrorState) {
            return const Text('blad');
          } else if (state is UserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.blue.shade900, blurRadius: 10, spreadRadius: 0.3),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Card(
                              shadowColor: Colors.black,
                              elevation: 5,
                              child: Column(
                                children: [
                                  LoginWidget(
                                    textInputType: TextInputType.emailAddress,
                                    text: "Email",
                                    controller: widget.mail,
                                  ),
                                  LoginWidget(
                                    text: "Nazwa użytkownika",
                                    controller: widget.userName,
                                  ),
                                  LoginWidget(
                                    textInputType: TextInputType.visiblePassword,
                                    text: "Hasło",
                                    controller: widget.password,
                                    obscureText: true,
                                  ),
                                  LoginWidget(
                                    text: "Powtórz Hasło",
                                    controller: widget.passwordConfirmation,
                                    obscureText: true,
                                  ),
                                  LoginWidget(
                                    text: "Imie",
                                    controller: widget.firstName,
                                  ),
                                  LoginWidget(
                                    text: "Nazwisko",
                                    controller: widget.lastName,
                                  ),
                                  LoginWidget(
                                    textInputType: TextInputType.phone,
                                    text: "Numer telefonu",
                                    controller: widget.phoneNumber,
                                  ),
                                  LoginWidget(
                                    textInputType: TextInputType.streetAddress,
                                    text: "Adres domowy",
                                    controller: widget.homeAddress,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            activeColor: Colors.green,
                                            value: checkedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                checkedValue = value!;
                                                role = 'driver';
                                              });
                                            }),
                                        const Text(
                                          "Czy chcesz byc kierowca?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(24, 69, 186, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: double.infinity,
                                    color: const Color.fromARGB(255, 42, 156, 65),
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      child: const Text(
                                        "Stwórz Konto",
                                        style: TextStyle(color: Colors.white, fontSize: 26),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            widget.mail.text.contains('@') &&
                                            widget.password.text == widget.password.text) {
                                          context.read<UserCubit>().registerUser(
                                                User(
                                                  idUser: 99,
                                                  email: widget.mail.text,
                                                  password: widget.password.text,
                                                  firstName: widget.firstName.text,
                                                  lastName: widget.lastName.text,
                                                  role: 'driver',
                                                  phoneNumber: widget.phoneNumber.text,
                                                  username: widget.homeAddress.text,
                                                  homeAddress: widget.homeAddress.text,
                                                  dateJoined: DateTime.now().toString(),
                                                  lastLogin: DateTime.now().toString(),
                                                  isActive: false,
                                                  isStaff: false,
                                                  isSuperuser: false,
                                                ),
                                              );

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Pomyślne zarejestrowanie')),
                                          );
                                          Navigator.of(context).pop();
                                        } else {}
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
