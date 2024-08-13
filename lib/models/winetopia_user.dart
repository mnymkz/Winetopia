class WinetopiaUser {
  final String uid;
  WinetopiaUser({required this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String fname;
  final String lname;
  final String phone;
  final int tokenAmount;
  UserData(
      {required this.uid,
      required this.email,
      required this.fname,
      required this.lname,
      required this.phone,
      required this.tokenAmount});
}
