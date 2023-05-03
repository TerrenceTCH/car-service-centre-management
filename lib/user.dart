import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String password;
  final String date;
  final String type;
  final String NRIC;
  final String city;
  final String dob;
  final String mail;
  final String name;
  final String phone;
  final String postCode;
  final String state;
  final String Uid;
  final String token;


  Users({
    this.email = '',
    this.date = '',
    this.password = '',
    this.type = '',
    this.NRIC = '',
    this.city = '',
    this.dob = '',
    this.mail = '',
    this.name = '',
    this.phone = '',
    this.postCode = '',
    this.state = '',
    this.Uid = '',
    this.token = ''
  });

  factory Users.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Users(
      email: data?['email'],
      password: data?['password'],
      date: data?['dateCreated'],
    );
  }

  Map<String, dynamic> toJson() => {
    'email' : email,
    'password' : password,
    'date' : date,
  };

  static Users fromJson(Map<String, dynamic> json) => Users(
    email: json['email'],
    password: json['password'],
    date: json['dateCreated'],
    type: json['userType'],
    NRIC: json['NRIC'],
    city: json['city'],
    dob: json['dob'],
    mail: json['mail'],
    name: json['name'],
    phone: json['phone'],
    postCode: json['postCode'],
    state: json['state'],
  );
}