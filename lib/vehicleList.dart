import 'package:car_service_management_application/vehicleObject.dart';
import 'package:car_service_management_application/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class vehicleList extends StatefulWidget {
  const vehicleList({Key? key}) : super(key: key);

  @override
  State<vehicleList> createState() => _vehicleListState();
}

class _vehicleListState extends State<vehicleList> {
  List<vehicleObject> vehicleList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.fromLTRB(72,65,10,75),
          child: Text('Vehicles', style: TextStyle(fontFamily: 'Mishella', fontSize: 30)),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<vehicleObject>>(
          future: getVehiclesList(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              vehicleList = snapshot.data!;
              return ListView.builder(
                  itemCount: vehicleList.length,
                  itemBuilder: (context, index){
                    return VehicleCard(vehicleList[index]);
                  }
              );
            }else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ),
    );
  }

  Future<List<vehicleObject>> getVehiclesList() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle');
    QuerySnapshot snapshot = await ref.get();

    if(snapshot.docs.length > 0){
      List<vehicleObject> dataList = [];
      dataList = snapshot.docs.map((doc) => vehicleObject(doc['NRIC'], doc['Model'], doc['Brand'], doc['Condition'], doc['LicensePlateNumber'], doc['Status'], doc['Uid'])).toList();
      if(dataList.length > 0){
        return Future.value(dataList);
      }
    }
    return Future.value([]);
  }
}
