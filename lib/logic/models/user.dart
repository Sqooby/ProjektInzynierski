// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  int idUser;
  String role;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String username;
  String homeAddress;
  String password;
  String lastLogin;
  bool isSuperuser;
  bool isStaff;
  bool isActive;
  String dateJoined;

  User(
      {required this.email,
      required this.password,
      this.idUser = 0,
      this.role = 'driver',
      this.firstName = 'Tomek ',
      this.lastName = 'Adam',
      this.phoneNumber = '11',
      this.username = '222',
      this.homeAddress = '22',
      this.lastLogin = '22',
      this.isSuperuser = false,
      this.isStaff = false,
      this.isActive = false,
      required this.dateJoined});
  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["id_user"],
        role: json["role"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        username: json["username"],
        homeAddress: json["home_address"],
        password: json["password"],
        lastLogin: json["last_login"],
        isSuperuser: json["is_superuser"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: json["date_joined"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "role": role,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "email": email,
        "username": username,
        "home_address": homeAddress,
        "password": password,
        "last_login": lastLogin,
        "is_superuser": isSuperuser,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined
      };
}
