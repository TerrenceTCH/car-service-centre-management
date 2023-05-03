import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_service_management_application/landing.dart';
import 'package:car_service_management_application/serviceCentre.dart';
import 'package:car_service_management_application/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forgotPassword.dart';
import 'homePage.dart';
import 'main.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Employee> empList = [];
  bool passwordVisibility = false;

  void _showLoginToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Login Successful!'),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: 200,
        elevation: 10,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _forgotPassword(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => forgotPassword()), (route) => false);
  }

  Future<Users?> readUser(String? id) async{
    print(id);
    final userdoc = FirebaseFirestore.instance.collection('users').doc(id);
    final snapshot = await userdoc.get();

    if(snapshot.exists){
      print("Im exist!");
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
                                    "Welcome Back!",
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
                                  onPressed: _forgotPassword,
                                  child: Text(
                                    "forgot password?",
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
                                  onPressed: ()  async {
                                    try{

                                      final login = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: emailAddressController.text.trim(),
                                        password: passwordController.text.trim(),
                                      ).then((value) {
                                        if(value!= null && value.user != null){
                                          print('Successful Login!');
                                          _showLoginToast(context);
                                          print(value.user!.uid);


                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')), (route) => false);
                                        }
                                        else{
                                          print('im here');
                                        }
                                      }).onError((error, stackTrace) {
                                        print('im here error');
                                        print(error);
                                      });
                                    }on FirebaseAuthException catch(e){
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        print('Wrong password provided for that user.');
                                      }
                                    }

                                  },
                                  child: Text(
                                    "Login",
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

  // Future<List<Employee>> getEmployees() async {
  //   print('im here');
  //   List<serviceCentre> scList = [];
  //   List<Employee> empList = [];
  //   CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre');
  //   QuerySnapshot snapshot = await ref.get();
  //   if(snapshot.docs.length > 0){
  //     scList = snapshot.docs.map((doc) => serviceCentre(doc['Name'], doc['State'], doc['City'], doc['Street'], doc['Postcode'], doc['Uid'], doc['ContactNumber'])).toList();
  //   }
  //
  //   for(serviceCentre sc in scList){
  //     QuerySnapshot snap = await ref.doc(sc.Uid).collection('Employees').get();
  //     List<Employee> temp = [];
  //     if(snap.docs.length > 0){
  //       temp = snap.docs.map((doc) => Employee(doc['BayInCharge'], doc['NRIC'], doc['Name'], doc['Position'], doc['Salary'], doc['WorkStatus'], doc['Uid'])).toList();
  //     }
  //     for(Employee emp in temp){
  //       empList.add(emp);
  //     }
  //     return Future.value(empList);
  //   }
  //   return Future.value([]);
  // }

}
