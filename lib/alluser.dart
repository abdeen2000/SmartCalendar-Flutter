import 'dart:ffi';

class alluser {
  String? uid;
  String? firstname;
  String? email;
  String? Lastname;

  alluser({this.uid, this.firstname, this.email, this.Lastname});
  factory alluser.fromMap(Map<String, dynamic> Map) {
    return alluser(
      uid: Map['uid'],
      firstname: Map['firstname'],
      email: Map['email'],
      Lastname: Map['Lastname'],
      
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'email': email,
      'Lastname': Lastname,
      
    };
  }
}
