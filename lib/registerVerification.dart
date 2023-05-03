import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_service_management_application/registerDetails.dart';
import 'package:car_service_management_application/registerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'landing.dart';

class regVerification extends StatefulWidget {
  const regVerification({Key? key}) : super(key: key);



  @override
  State<regVerification> createState() => _regVerificationState();
}

class _regVerificationState extends State<regVerification> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Timer timer = Timer.periodic(Duration(seconds: 5), (timer) {

  });
  late User user;

  @override
  void initState(){
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkUserVerified();
    });
    super.initState();
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return regVerification();
      },
    );
  }

  Future<void> checkUserVerified() async {
    User user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => registerDetailsPage()), (route) => false);
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
                                    "Verify Check Stage!",
                                    style: TextStyle(fontFamily: 'Daviton', fontSize: 40, color: Colors.black),
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
                                  child: Text(
                                    "An email has been sent to ${user.email} for verification! Please check your email!",
                                    style: TextStyle(fontSize: 20, fontFamily: 'Louis', color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: CircularProgressIndicator(

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
