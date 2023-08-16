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
}
