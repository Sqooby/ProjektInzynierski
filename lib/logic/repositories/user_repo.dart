import 'dart:convert';

import '../models/user.dart';

import 'package:http/http.dart' as http;

class UserRepo {
  final String url = 'https://demo1.drt.kia.prz.edu.pl/api/user/';
  Future<List<User>> getUser() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final result = json.map((e) {
        return User(
          idUser: e['id_user'],
          role: e['role'],
          firstName: e['first_name'],
          lastName: e['last_name'],
          phoneNumber: e['phone_number'],
          email: e['email'],
          username: e['username'],
          homeAddress: e['home_address'],
          password: e['password'],
          lastLogin: e['last_login'],
          // isSuperuser: e['is_superuser'],
          // isStaff: e['is_staff'],
          // isActive: e['is_active'],
          dateJoined: e['date_joined'],
        );
      }).toList();

      return result;
    } else {
      throw '${response.statusCode}';
    }
  }

  Future<void> registerUser(User user) async {
    final uri = Uri.parse(url);
    final Map<String, dynamic> body = {
      'email': user.email,
      'password': user.password,
      "role": user.role,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "phone_number": user.phoneNumber,
      "username": user.username,
      "home_address": user.homeAddress,
      "last_login": user.lastLogin,
      "is_superuser": user.isSuperuser,
      "is_staff": user.isStaff,
      "is_active": user.isActive,
      "date_joined": user.dateJoined,
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {}
  }
}
