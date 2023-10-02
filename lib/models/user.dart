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
  User({
    required this.idUser,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.username,
    required this.homeAddress,
    required this.password,
    required this.lastLogin,
    required this.isSuperuser,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUser': idUser,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'username': username,
      'homeAddress': homeAddress,
      'password': password,
      'lastLogin': lastLogin,
      'isSuperuser': isSuperuser,
      'isStaff': isStaff,
      'isActive': isActive,
      'dateJoined': dateJoined,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'] as int,
      role: map['role'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      homeAddress: map['homeAddress'] as String,
      password: map['password'] as String,
      lastLogin: map['lastLogin'] as String,
      isSuperuser: map['isSuperuser'] as bool,
      isStaff: map['isStaff'] as bool,
      isActive: map['isActive'] as bool,
      dateJoined: map['dateJoined'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
