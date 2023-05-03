import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'landing.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController emailAddressController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _showForgetPasswordToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Reset link has been sent!'),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: 200,
        elevation: 10,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future resetPassword() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddressController.text.trim());
      _showForgetPasswordToast;
      Navigator.of(context).popUntil((route) => route.isFirst);

    }on FirebaseAuthException catch (e){
      print(e);

      Navigator.of(context).pop();

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
                      Text("Forgot Password", style: TextStyle(fontSize: 35, fontFamily: 'Louis', color: Colors.black),),
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
                                    "Reset your password!",
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
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (email) =>
                                        email != null && !EmailValidator.validate(email)
                                          ? 'Enter a valid email'
                                          : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 16),
                            child: ElevatedButton(
                              onPressed: resetPassword,
                              child: Text(
                                "Reset Password",
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
