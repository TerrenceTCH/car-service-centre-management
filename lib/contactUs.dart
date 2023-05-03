import 'package:car_service_management_application/contactCard.dart';
import 'package:car_service_management_application/serviceCentre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class contactUs extends StatefulWidget {
  const contactUs({Key? key}) : super(key: key);

  @override
  State<contactUs> createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<serviceCentre> serviceCentres = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.fromLTRB(72,65,10,75),
          child: Text('Contact Us', style: TextStyle(fontFamily: 'Mishella', fontSize: 30)),
        ),
      ),
      body: SafeArea(
          child: FutureBuilder<List<serviceCentre>>(
            future: getAllServiceCentresToList(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                serviceCentres = snapshot.data!;
                return ListView.builder(
                    itemCount: serviceCentres.length,
                    itemBuilder: (context, index){
                      return contactCard(serviceCentres[index]);
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

  Future<List<serviceCentre>> getAllServiceCentresToList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre');
    QuerySnapshot snapshot = await ref.get();

    if(snapshot.docs.length > 0){
      List<serviceCentre> dataList = [];
      dataList = snapshot.docs.map((doc) => serviceCentre(doc['Name'], doc['State'], doc['City'], doc['Street'], doc['Postcode'], doc['Uid'], doc['ContactNumber'])).toList();
      if(dataList.length > 0){
        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

}
