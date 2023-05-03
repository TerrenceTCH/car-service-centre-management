import 'package:car_service_management_application/addVehicle.dart';
import 'package:car_service_management_application/booking.dart';
import 'package:car_service_management_application/bookingList.dart';
import 'package:car_service_management_application/main.dart';
import 'package:car_service_management_application/my_flutter_app_icons.dart';
import 'package:car_service_management_application/profile.dart';
import 'package:car_service_management_application/progressPage.dart';
import 'package:car_service_management_application/user.dart';
import 'package:car_service_management_application/vehicleList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:car_service_management_application/feature.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'contactUs.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {


  void barPressed(String page){
    if(page.compareTo("booking") == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => featurePlace()));
    }
    else if(page.compareTo("contact") == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => contactUs()));
    }
    else if(page.compareTo("appointment") == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => contactUs()));
    }
  }

  List<bool> isSelected = [false,false,false];
  String deviceToken = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(30),
                child: Text('For You', style: TextStyle(fontSize: 40, fontFamily: 'Daviton'),)
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<String>(
                  future: getDeviceToken(),
                  builder: (context,snapshot){
                    deviceToken = snapshot.data!;
                    print(deviceToken);
                    return Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/bgGif.gif'), fit: BoxFit.cover
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height / 7.3,
              child: ToggleButtons(
                isSelected: isSelected,
                borderColor: Colors.black26,
                disabledColor: Colors.cyan,
                color: Colors.black,
                selectedColor: Colors.white,
                fillColor: Colors.blue.shade500,
                splashColor: Colors.blue.shade100,
                borderWidth: 2,
                selectedBorderColor: Colors.black,
                borderRadius: BorderRadius.circular(35),
                children: <Widget>[
                  SizedBox(
                    width: 74,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                              child: Icon(Icons.car_repair),
                          ),
                          Text('Vehicles', style: TextStyle(fontSize: 18, fontFamily: 'Louis')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 74,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 11, 0, 2),
                            child: Icon(Icons.calendar_month),
                          ),
                          Text('Book Now', style: TextStyle(fontSize: 17, fontFamily: 'Louis')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 74,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                            child: Icon(MyFlutterApp.applogo__1_),
                          ),
                          Text('Bookings', style: TextStyle(fontSize: 18, fontFamily: 'Louis')),
                        ],
                      ),
                    ),
                  ),
                ],
                onPressed: (int newIndex) {
                  setState(() {
                    for(int index = 0; index < isSelected.length; index++){
                      if(index == newIndex){
                        isSelected[index] = true;
                        if(newIndex == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => vehicleList()));
                        }
                        else if(newIndex == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => booking()));
                        }
                        else if(newIndex == 2){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => bookingListPage()));
                        }
                      }
                      else{
                        isSelected[index] = false;
                      }
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getDeviceToken() async{
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessaging.getToken();
    print('im here ${deviceToken}');
    if(deviceToken!.isNotEmpty){
      final docRef = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid);
      await docRef.update({
        'token': deviceToken
      }).catchError((error){
        print(error);
      });
    }
    return Future.value(deviceToken);
  }
}
