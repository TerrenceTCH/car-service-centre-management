import 'package:car_service_management_application/loginPage.dart';
import 'package:car_service_management_application/registerVerification.dart';
import 'package:car_service_management_application/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'landing.dart';
import 'main.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisibility = false;


  void _gotoLogin(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginPage()), (route) => false);
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;


  }

  Future<Users?> readUser(String? id) async{
    final userdoc = FirebaseFirestore.instance.collection('users').doc(id.toString());
    final snapshot = await userdoc.get();

    if(snapshot.exists){
      return Users.fromJson(snapshot.data()!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        Text("Car Days", style: TextStyle(fontSize: 35, fontFamily: 'Louis', color: Colors.black),),
                      ],
                    ),
                ),
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
                                      "Get Started!",
                                      style: TextStyle(fontFamily: 'Daviton', fontSize: 40, color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async{
                                      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => landingPage()) , (route) => false);
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
                                          await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => landingPage()), (route) => false);
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
                                        controller: emailAddressController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: "Email Address",
                                          labelStyle: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Louis',
                                            color: Color(0xFF95A1AC),
                                          ),
                                          hintText: "Enter your email address here.",
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
                                      controller: passwordController,
                                      obscureText: !passwordVisibility,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Louis',
                                          color: Color(0xFF95A1AC),
                                        ),
                                        hintText: "Enter your password here.",
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
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                              () => passwordVisibility = !passwordVisibility,
                                          ),
                                          focusNode: FocusNode(skipTraversal: true),
                                          child: Icon(
                                            passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF95A1AC),
                                            size: 22,
                                          ),
                                        ),
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
                                    onPressed: _gotoLogin,
                                    child: Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Louis',
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(color: Colors.transparent)
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async => {
                                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                            email: emailAddressController.text,
                                            password: passwordController.text,
                                        ).then((value) {
                                          DateTime now = new DateTime.now();
                                          DateTime date = new DateTime(now.year, now.month, now.day);
                                          String dateString = date.toString();
                                          if(value != null && value.user != null){
                                            final userdetails = <String, String>{
                                              "email" : emailAddressController.text,
                                              "password" : passwordController.text,
                                              "userType" : "user",
                                              "dateCreated" : convertDateTimeDisplay(dateString),
                                              "Uid" : value.user!.uid,
                                            };
                                            FirebaseFirestore.instance.collection("users").doc(value.user?.uid).set(
                                              userdetails
                                            ).onError((error, stackTrace) {
                                              print("Error occured in fireStore!");
                                              print("${error.toString()}");
                                            });
                                            print("account created successfully!");
                                            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (content) => regVerification()), (route) => false);
                                          }

                                        }).onError((error, stackTrace) {
                                          print("Error occured in auth!");
                                          print("${error.toString()}");
                                        })
                                      },
                                      child: Text(
                                        "Create",
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
      ),
    );
  }
}
