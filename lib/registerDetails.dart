import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_service_management_application/registerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addVehicle.dart';

class registerDetailsPage extends StatefulWidget {
  const registerDetailsPage({Key? key}) : super(key: key);

  @override
  State<registerDetailsPage> createState() => _registerDetailsPageState();
}

class _registerDetailsPageState extends State<registerDetailsPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController NRICController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();


  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return registerDetailsPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.cyanAccent, Colors.blueAccent]
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: Align(
                alignment: AlignmentDirectional(0,1),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 70, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Knowing you!", style: TextStyle(fontSize: 35, fontFamily: 'Louis', color: Colors.black),),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 380,
                        height: 414,
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: AutoSizeText(
                                                "Help us get to know more about you!",
                                                style: TextStyle(fontFamily: 'Daviton', fontSize: 30, color: Colors.black),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async{
                                                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => registerPage()) , (route) => false);
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Color(0xFFDBE2E7),
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => registerPage()), (route) => false);
                                                  },
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: Color(0xFF090F13),
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: NRICController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "NRIC No.",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your malaysian identity card number here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: phoneNoController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "Phone number",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your phone number.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: nameController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "Full name",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your full name here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                controller: dobController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "Date of Birth",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                readOnly: true,
                                                onTap: () async{
                                                  DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2050)
                                                  );

                                                  if(pickedDate != null){
                                                    print(pickedDate);
                                                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

                                                    setState((){
                                                      dobController.text = formattedDate;
                                                    });
                                                  }

                                                  else{
                                                    print('Date is not selected');
                                                  }

                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 2,
                                        thickness: 2,
                                        indent: 20,
                                        endIndent: 20,
                                        color: Color(0xFFDBE2E7),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: mailController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "Mailing Address",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your mailing address here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: postCodeController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "Post Code",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your post code here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: cityController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "City",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your city here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFormField(
                                                controller: stateController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: "State",
                                                  labelStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  hintText: "Enter your state here.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Louis',
                                                    color: Color(0xFF95A1AC),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Louis',
                                                  fontSize: 20,
                                                  color: Color(0xFF2B343A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            ElevatedButton(
                                              onPressed: () async => {
                                                await FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).set(
                                                    userInfoToBeEntered(NRICController.text, phoneNoController.text, nameController.text, dobController.text, mailController.text, postCodeController.text, cityController.text, stateController.text),
                                                    SetOptions(merge: true)
                                                ).onError((error, stackTrace) {
                                                  print("Error occured in fireStore!");
                                                  print("${error.toString()}");
                                                }),
                                                print("user info added successfully!"),
                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (content) => addVehicle()), (route) => false),
                                              },
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'Louis',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                fixedSize: MaterialStateProperty.all<Size>(Size(110, 50)),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );



  }

  Map<String, String> userInfoToBeEntered(String NRIC, String phone, String name, String dob, String mail, String postCode, String city, String state) {
    Map<String, String> info = {
      "NRIC" : NRIC,
      "phone" : phone,
      "name" : name,
      "dob" : dob,
      "mail" : mail,
      "postCode" : postCode,
      "city" : city,
      "state" : state,
    };

    return info;
  }
}
