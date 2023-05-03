import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:car_service_management_application/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'booking.dart';
import 'main.dart';

class MechanicVehicleDetails extends StatefulWidget {
  const MechanicVehicleDetails({Key? key, required this.vehicle}) : super(key: key);

  final vehicleObject vehicle;
  @override
  State<MechanicVehicleDetails> createState() => _MechanicVehicleDetailsState();
}

class _MechanicVehicleDetailsState extends State<MechanicVehicleDetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<vehicleObject> vehicleList = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  GlobalKey<FormState> updateVehicleFormKey = GlobalKey<FormState>();
  TextEditingController NRICController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleStatusController = TextEditingController();
  List<vehicleCondition> vehicleConditionList = [];
  String initialSelectedCondition = '';
  List<String> vehicleStatusImages = [];
  List<XFile> images = [];
  String vehicleUploadStatus = "";
  @override
  void initState(){
    super.initState();
    NRICController.text = widget.vehicle.NRIC;
    licensePlateController.text = widget.vehicle.LicensePlateNumber;
    vehicleModelController.text = widget.vehicle.Model;
    vehicleBrandController.text = widget.vehicle.Brand;
    initialSelectedCondition = widget.vehicle.Condition;
    vehicleStatusController.text = widget.vehicle.Status;
    //read the images from firebase storage
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
                                "Vehicle Details",
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
                                  return ListView(
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
                                                          "Vehicle Details",
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
                                                          readOnly: true,
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
                                                          controller: licensePlateController,
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
                                                          readOnly: true,
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
                                                          readOnly: true,
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
                                                          readOnly: true,
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
                                                          controller: vehicleStatusController,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            labelText: "Vehicle Status",
                                                            labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: 'Louis',
                                                              color: Color(0xFF95A1AC),
                                                            ),
                                                            hintText: "Enter your vehicle status here.",
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
                                                                  value: initialSelectedCondition,

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
                                                                    initialSelectedCondition = value.toString();
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
                                                // Padding(
                                                //   padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                                //   child: ElevatedButton(
                                                //     onPressed: () async {
                                                //       images = await ImagePicker().pickMultiImage();
                                                //       if (images != null) {
                                                //         vehicleStatusImages = await uploadMultipleImages(images);
                                                //         for(String img in vehicleStatusImages){
                                                //           print(img);
                                                //         }
                                                //         setState((){
                                                //           if(vehicleStatusImages.isNotEmpty){
                                                //             String delimiter = '|';
                                                //             vehicleUploadStatus = vehicleStatusImages.join(delimiter);
                                                //           }
                                                //           print(vehicleStatusImages.length);
                                                //           loadInitialImages();
                                                //         });
                                                //       }
                                                //     },
                                                //     child: Text(
                                                //       "Upload Car Image",
                                                //       style: TextStyle(
                                                //         fontSize: 22,
                                                //         fontFamily: 'Louis',
                                                //         fontWeight: FontWeight.bold,
                                                //         color: Colors.white,
                                                //       ),
                                                //     ),
                                                //     style: ButtonStyle(
                                                //       fixedSize: MaterialStateProperty.all<Size>(Size(230, 50)),
                                                //       backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                                                //       foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                                                //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                //         RoundedRectangleBorder(
                                                //             borderRadius: BorderRadius.circular(15),
                                                //             side: BorderSide(color: Colors.transparent)
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 16),
                                                  child: FutureBuilder<List<String>>(
                                                    future: loadInitialImages(),
                                                    builder: (context, snapshot){
                                                      if(snapshot.hasData){
                                                        vehicleStatusImages = snapshot.data!;
                                                        return GridView.count(
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
                                                        );
                                                      }else if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return Center(child: CircularProgressIndicator());
                                                      }
                                                    },
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
                                                          await updateVehicle();
                                                        },
                                                        child: Text(
                                                          "Confirm vehicle",
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
  Future<List<String>> uploadMultipleImages(List<XFile> imageList) async {
    List<String> downloadUrls = [];
    int count = 0;
    for (XFile imageFile in imageList) {
      try {
        Reference storageRef = storage
            .ref()
            .child('images/${auth.currentUser?.uid}/${widget.vehicle.Uid.trim()}/${count}');
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

  Future<List<String>> loadInitialImages () async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference folderRef = storage.ref().child('images/${auth.currentUser?.uid}/${widget.vehicle.Uid}/');
    List<String> images = [];
    ListResult result = await folderRef.listAll();
    for(Reference ref in result.items){
      images.add(await ref.getDownloadURL());
    }
    return Future.value(images);
  }

  Future<void> uploadVehicleImages() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference folderRef = storage.ref().child('images/${auth.currentUser?.uid}/${widget.vehicle.Uid.trim()}/');
    print('im here to check uid ${auth.currentUser?.uid} and${widget.vehicle.Uid.trim()}');
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
            .child('images/${auth.currentUser?.uid}/${widget.vehicle.Uid.trim()}/${count}');
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      } catch (e) {
        print(e.toString());

      }
      count++;
    }

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
  Map<String, String> vehicleInfoToBeEntered(String NRIC, String licensePlateNo,  String vehicleModel, String vehicleBrand, String vehicleCondition) {
    Map<String, String> info = {
      "NRIC" : NRIC,
      "LicensePlateNumber" : licensePlateNo,
      "Model" : vehicleModel,
      "Brand" : vehicleBrand,
      "Condition" : vehicleCondition,
      "Status": 'Confirmed',
      "Uid": widget.vehicle.Uid
    };

    return info;
  }

  Future<void> updateVehicle() async{
    await FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle').doc(widget.vehicle.Uid).update(
        vehicleInfoToBeEntered(NRICController.text, licensePlateController.text, vehicleModelController.text, vehicleBrandController.text, initialSelectedCondition)
    ).then((value) async {
      await uploadVehicleImages();
    }).catchError((error) {
      print(error.toString());
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Update Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (content) => MyHomePage(title: '')), (route) => false);

  }


}
