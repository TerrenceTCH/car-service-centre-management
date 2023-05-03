
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_service_management_application/user.dart';
import 'package:car_service_management_application/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'booking.dart';
import 'main.dart';

class addVehicle extends StatefulWidget {
  const addVehicle({Key? key, this.detectedCarPlate}) : super(key: key);

  final String? detectedCarPlate;
  @override
  State<addVehicle> createState() => _addVehicleState();
}

class _addVehicleState extends State<addVehicle> {

  TextEditingController NRICController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleConditionController = TextEditingController();
  String vehicleConditionSelectedValue = '';
  String vehicleUploadStatus = "";
  List<String> vehicleStatusImages = [];
  bool vehicleExists = false;
  bool validVehicle = false;
  FocusNode licensePlateFocusNode = FocusNode();
  FocusNode vehicleModelFocusNode = FocusNode();
  GlobalKey<FormState> addVehicleFormKey = GlobalKey<FormState>();
  List<vehicleObject> vehicleList = [];
  List<vehicleCondition> vehicleConditionList = [];
  List<XFile> images = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Users?> readUser(String? id) async{
    final userdoc = FirebaseFirestore.instance.collection('users').doc(id.toString());
    final snapshot = await userdoc.get();

    if(snapshot.exists){
      return Users.fromJson(snapshot.data()!);
    }

  }
  @override
  void dispose() {
    licensePlateFocusNode.dispose();
    vehicleModelFocusNode.dispose();
    super.dispose();
  }
  @override
  void initState(){
    if(widget.detectedCarPlate?.length != null){
      licensePlateController.text = widget.detectedCarPlate!;
    }
    super.initState();
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 70, 20, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Add your vehicle!",
                                style: TextStyle(fontSize: 35, fontFamily: 'Louis', color: Colors.black),
                              ),
                              InkWell(
                                onTap: () async{
                                  await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')) , (route) => false);
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
                                      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')), (route) => false);
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF090F13),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: FutureBuilder<List<vehicleObject>>(
                            future: getAllVehiclesToList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                vehicleList = snapshot.data!;
                                return Form(
                                  key: addVehicleFormKey,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                                                          "Add your vehicle!",
                                                          style: TextStyle(fontFamily: 'Daviton', fontSize: 30, color: Colors.black),
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
                                                        child: FutureBuilder<Users?>(
                                                          future: readUser(auth.currentUser?.uid),
                                                          builder: (context, snapshot) {
                                                            if(snapshot.hasError){
                                                              print(snapshot.error.toString());
                                                              return Text('Something went wrong!');
                                                            }
                                                            if(snapshot.hasData){
                                                              final user = snapshot.data;
                                                              String userIC = '${user?.NRIC}';
                                                              NRICController.text = userIC;
                                                              return TextFormField(
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
                                                                readOnly: true,
                                                              );
                                                            }
                                                            else{
                                                              return Center(
                                                                child: CircularProgressIndicator(

                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 20),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextFormField(
                                                          focusNode: licensePlateFocusNode,
                                                          controller: licensePlateController,
                                                          validator: (value) {
                                                            RegExp licensePattern = RegExp(r'^[a-zA-Z]{1,3}\d{1,4}[a-zA-Z]?$');
                                                            if(licensePattern.hasMatch(value!)){
                                                              if(vehicleList.isNotEmpty){
                                                                for(vehicleObject obj in vehicleList){
                                                                  if(value?.trim().compareTo(obj.LicensePlateNumber) == 0){
                                                                    return 'vehicle existed!';
                                                                  }
                                                                }
                                                              }
                                                            }
                                                            else{
                                                              return 'Invalid License Plate Number format!';
                                                            }
                                                            return null;
                                                          },
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            labelText: "License Plate No:",
                                                            labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: 'Louis',
                                                              color: Color(0xFF95A1AC),
                                                            ),
                                                            hintText: "Enter your license plate number here.",
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
                                                          focusNode: vehicleModelFocusNode,
                                                          controller: vehicleModelController,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            labelText: "Vehicle Model",
                                                            labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: 'Louis',
                                                              color: Color(0xFF95A1AC),
                                                            ),
                                                            hintText: "Enter your vehicle model here.",
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
                                                          controller: vehicleBrandController,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            labelText: "Vehicle Brand",
                                                            labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: 'Louis',
                                                              color: Color(0xFF95A1AC),
                                                            ),
                                                            hintText: "Enter your vehicle brand here.",
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
                                                        child: FutureBuilder<List<vehicleCondition>>(
                                                          future: getAllVehicleCondition(),
                                                          builder: (context, snapshot) {
                                                            if(snapshot.hasData){
                                                              vehicleConditionList = snapshot.data!;
                                                              return DropdownButtonFormField2(
                                                                decoration: InputDecoration(
                                                                  //Add isDense true and zero Padding.
                                                                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.zero,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: Colors.white70
                                                                  //Add more decoration as you want here
                                                                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                ),
                                                                isExpanded: true,
                                                                hint: const Text(
                                                                  'Choose your vehicle condition',
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                                iconStyleData: const IconStyleData(
                                                                  icon : Icon(Icons.arrow_drop_down, color: Colors.black45,),
                                                                  iconSize: 30,
                                                                ),
                                                                buttonStyleData: const ButtonStyleData(height : 60, padding: const EdgeInsets.only(left: 3, right: 10)),
                                                                dropdownStyleData : DropdownStyleData(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                  ),
                                                                ),
                                                                items: vehicleConditionList
                                                                    .map((item) =>
                                                                    DropdownMenuItem<String>(
                                                                      value: item.Name,
                                                                      child: Text(
                                                                        item.Name,
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ))
                                                                    .toList(),
                                                                validator: (value) {
                                                                  if (value == null) {
                                                                    return 'Please select service type.';
                                                                  }
                                                                },
                                                                onChanged: (value) {
                                                                  vehicleConditionSelectedValue = value.toString();
                                                                },
                                                                onSaved: (value) {

                                                                },
                                                              );
                                                            }
                                                            else if (snapshot.hasError) {
                                                              return Text('Error: ${snapshot.error}');
                                                            } else {
                                                              return Center(child: CircularProgressIndicator());
                                                            }
                                                          }
                                                        ),

                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      images = await ImagePicker().pickMultiImage();
                                                      if (images != null) {
                                                        vehicleStatusImages = await uploadMultipleImages(images);
                                                        for(String img in vehicleStatusImages){
                                                          print(img);
                                                        }
                                                        setState((){
                                                          if(vehicleStatusImages.isNotEmpty){
                                                            String delimiter = '|';
                                                            vehicleUploadStatus = vehicleStatusImages.join(delimiter);
                                                          }
                                                          print(vehicleStatusImages.length);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      "Upload Car Image",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontFamily: 'Louis',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: ButtonStyle(
                                                      fixedSize: MaterialStateProperty.all<Size>(Size(230, 50)),
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
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 16),
                                                  child: GridView.count(
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    children: vehicleStatusImages.map((url) {
                                                      return CachedNetworkImage(
                                                        imageUrl: url,
                                                        placeholder: (context, url) => CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 16),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if(addVehicleFormKey.currentState!.validate()){
                                                            print('im here');
                                                            addVehicleFormKey.currentState!.save();
                                                            await addVehicle();
                                                          }
                                                          else{
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text('Invalid information! Please check for invalid fields.'),
                                                                duration: Duration(seconds: 2),
                                                              ),
                                                            );
                                                          }
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
                                );

                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            }
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },

        ),
      ),
    );

  }

  Future<int> totalVehicles() async {
    final int vehicles = await FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle').snapshots().length;
    return vehicles;
  }
  Map<String, String> vehicleInfoToBeEntered(String NRIC, String licensePlateNo,  String vehicleModel, String vehicleBrand, String vehicleCondition) {
    Map<String, String> info = {
      "NRIC" : NRIC,
      "LicensePlateNumber" : licensePlateNo,
      "Model" : vehicleModel,
      "Brand" : vehicleBrand,
      "Condition" : vehicleCondition,
      "Status": 'New'
    };

    return info;
  }
  Future<List<String>> uploadMultipleImages(List<XFile> imageList) async {
    List<String> downloadUrls = [];
    int count = 0;
    for (XFile imageFile in imageList) {
      try {
        Reference storageRef = storage
            .ref()
            .child('images/${auth.currentUser?.uid}/vehicle/${count}');
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print(e.toString());
        return downloadUrls;
      }
      count++;
    }

    return downloadUrls;
  }

  Future<void> uploadVehicleImages(String uid) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference folderRef = storage.ref().child('images/${auth.currentUser?.uid}/vehicle/');

    await folderRef.listAll().then((result) {
      List<Reference> files = result.items;

      // Delete all files inside the folder
      for (Reference file in files) {
        file.delete();
      }

      // Delete the folder itself
      folderRef.delete().then((_) {
        print('Folder deleted successfully.');
      }).catchError((error) {
        print('Error deleting folder: $error');
      });
    }).catchError((error) {
      print('Error listing files and folders inside the folder: $error');
    });

    int count = 0;
    for (XFile imageFile in images) {
      try {
        Reference storageRef = storage
            .ref()
            .child('images/${auth.currentUser?.uid}/${uid}/${count}');
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      } catch (e) {
        print(e.toString());

      }
      count++;
    }

  }

  Future<void> addVehicle() async{
    DocumentReference newVehicleRef = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle').doc();
    String uid = newVehicleRef.id;
    await newVehicleRef.set(
      {
        "NRIC" : NRICController.text,
        "LicensePlateNumber" : licensePlateController.text,
        "Model" : vehicleModelController.text,
        "Brand" : vehicleBrandController.text,
        "Condition" : vehicleConditionSelectedValue,
        "Status": 'New',
        "Uid":uid
      }
    ).then((value) async {
      await uploadVehicleImages(uid);
    }).catchError((error) {
      print(error.toString());
    });
    print("vehicle info added successfully!");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (content) => MyHomePage(title: '')), (route) => false);

  }

  // Future<void> fetchFiles() async {
  //   try {
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     // Create a reference to the folder
  //     Reference folderRef = storage.ref().child('myFolder');
  //
  //     // Fetch all the items (files and folders) in the folder
  //     ListResult result = await folderRef.listAll();
  //
  //     // Iterate over each item and add the file names to the list
  //     result.items.forEach((Reference ref) {
  //       fileNames.add(ref.name);
  //     });
  //   } catch (e) {
  //     print('Error fetching files: $e');
  //   }
  // }

  void onLicensePlateInput(String licensePlate) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle');
    QuerySnapshot snapshot = await ref.get();
    print('hi ${snapshot.docs.length}');
    List<vehicleObject> dataList = [];
    dataList = snapshot.docs.map((doc) => vehicleObject(doc['NRIC'], doc['Model'], doc['Brand'], doc['Condition'], doc['LicensePlateNumber'], doc['Status'], doc['Uid'])).toList();
    print('hi ${dataList.length}');
    for(vehicleObject obj in dataList){
      print(obj.LicensePlateNumber);
    }
    setState((){
      print('im here22');
      if(licensePlate.isNotEmpty){
        vehicleExists = !vehicleExists;
        print('im here');
      }
    });

  }


  Future<List<vehicleObject>> getAllVehiclesToList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<vehicleObject> dataList = [];
      dataList = snapshot.docs.map((doc) => vehicleObject(doc['NRIC'], doc['Model'], doc['Brand'], doc['Condition'], doc['LicensePlateNumber'], doc['Status'], doc['Uid'])).toList();
      if(dataList.length > 0){

        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

  Future<List<vehicleCondition>> getAllVehicleCondition() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('VehicleCondition');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<vehicleCondition> dataList = [];
      dataList = snapshot.docs.map((doc) => vehicleCondition(doc['Name'], doc['Description'])).toList();
      if(dataList.length > 0){

        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

}
