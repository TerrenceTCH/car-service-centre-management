
import 'package:car_service_management_application/bookingObject.dart';
import 'package:car_service_management_application/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'booking_card.dart';

class bookingListPage extends StatefulWidget {
  const bookingListPage({Key? key}) : super(key: key);

  @override
  State<bookingListPage> createState() => _bookingListPageState();
}

class _bookingListPageState extends State<bookingListPage> {
  List<bookingObject> bookingList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.fromLTRB(72,65,10,75),
          child: Text('Bookings', style: TextStyle(fontFamily: 'Mishella', fontSize: 30)),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<bookingObject>>(
          future: getAllBookingsToList(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              bookingList = snapshot.data!;
              return ListView.builder(
                  itemCount: bookingList.length,
                  itemBuilder: (context, index){
                    return bookingCard(bookingList[index]);
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

  Future<List<bookingObject>> getAllBookingsToList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('booking');
    QuerySnapshot snapshot = await ref.get();

    if(snapshot.docs.length > 0){
      List<bookingObject> dataList = [];
      dataList = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
      print('im here checkign dataList length = ${dataList.length} in booking list');
      if(dataList.length > 0){
        List<bookingObject> temp = [];
        for(bookingObject b in dataList){
          if(b.Status.compareTo('Rejected') != 0){
            temp.add(b);
          }
        }
        print(temp.length);
        return Future.value(temp);
      }
    }
    return Future.value([]);

  }
}
