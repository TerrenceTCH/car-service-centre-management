import 'package:car_service_management_application/profileCard.dart';
import 'package:car_service_management_application/serviceCentre.dart';
import 'package:car_service_management_application/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'landing.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  List<Employee> empList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  void signOut(){
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => landingPage()), (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<Users?>(
                future: readUser(auth.currentUser?.uid),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final user = snapshot.data!;
                    return ProfileCard(user);
                  }else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: signOut,
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Louis',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.transparent)
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
        
      ),
    );
  }

  Future<Users?> readUser(String? id) async{
    final userdoc = FirebaseFirestore.instance.collection('users').doc(id.toString());
    final snapshot = await userdoc.get();

    if(snapshot.exists){
      return Users.fromJson(snapshot.data()!);
    }

  }
}
