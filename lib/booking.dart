import 'dart:developer';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:car_service_management_application/bookingObject.dart';
import 'package:car_service_management_application/serviceCentre.dart';
import 'package:car_service_management_application/vehicleObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';

class booking extends StatefulWidget {
  const booking({Key? key}) : super(key: key);

  @override
  State<booking> createState() => _bookingState();
}

class _bookingState extends State<booking> {

  TextEditingController serviceCentreController = TextEditingController();
  TextEditingController serviceDateController = TextEditingController();
  String serviceCentreSelectedValue = '';
  GlobalKey<FormState> addBookingFormKey = GlobalKey<FormState>();
  bool selectedServiceDate = false;
  bool selectedServiceCentre = false;
  bool selectedServiceTimeSlot = false;
  bool isInMinorOnly = false;
  bool isInMajorAndMinor = false;
  bool isInMajorAndMinorExtra = false;
  String selectedVehicle = '';
  String selectedTimeSlotUid='';
  String selectedServiceBayUid='';
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool isTodayOffDay = false;
  final int length = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> serviceTypeAvailable = [];
  List<vehicleObject> vehicles = [];
  List<serviceCentre> serviceCentres = [];
  List<offDays> serviceCentreOffDays = [];
  List<DateTime> DisallowedDates = [];
  List<TimeSlot> chosenServiceCentreAvailableTimeSlots = [];
  List<String> AllowedTime = [];
  late DateTime ServiceDateInDate;
  String selectedTime = '';
  String? selectedValue;
  String selectedServiceCentreUid = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.redAccent.shade100, Colors.blueAccent.shade100]
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                            Text("Booking Stage!", style: TextStyle(
                                fontSize: 35,
                                fontFamily: 'Louis',
                                color: Colors.black),),
                            InkWell(
                              onTap: () async {
                                await Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) =>
                                        MyHomePage(title: 'home')), (
                                        route) => false);
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
                                    await Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) =>
                                            MyHomePage(title: 'home')), (
                                            route) => false);
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
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: FutureBuilder<List<serviceCentre>>(
                            future: getAllServiceCentres(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                serviceCentres = snapshot.data!;
                                return Form(
                                  key: addBookingFormKey,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 36, 0, 0),
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0, 3, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 16, 20, 0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          "Make a booking now!",
                                                          style: TextStyle(
                                                              fontFamily: 'Daviton',
                                                              fontSize: 30,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 16, 20, 0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: FutureBuilder<
                                                            List<vehicleObject>>(
                                                          future: getAllVehiclesToList(),
                                                          builder: (context, snapshot) {
                                                            if (!snapshot.hasData) {
                                                              print(auth.currentUser
                                                                  ?.uid);
                                                              print(snapshot.data);
                                                              return CircularProgressIndicator();
                                                            }
                                                            else {
                                                              vehicles = snapshot.data!;
                                                              return Row(
                                                                mainAxisSize: MainAxisSize
                                                                    .max,
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: DropdownButtonFormField2(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets
                                                                            .zero,
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              15),
                                                                        ),
                                                                        //Add more decoration as you want here
                                                                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                      ),
                                                                      isExpanded: true,
                                                                      hint: Text(
                                                                        'Select Your Vehicle',
                                                                        style: TextStyle(
                                                                            fontSize: 14),
                                                                      ),
                                                                      iconStyleData: const IconStyleData(
                                                                        icon: Icon(Icons
                                                                            .arrow_drop_down,
                                                                          color: Colors
                                                                              .black45,),
                                                                        iconSize: 30,
                                                                      ),
                                                                      buttonStyleData: const ButtonStyleData(
                                                                          height: 60,
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 20,
                                                                              right: 10)),
                                                                      dropdownStyleData: DropdownStyleData(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              15),
                                                                        ),
                                                                      ),
                                                                      items: vehicles
                                                                          .map((item) =>
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value: item
                                                                                .LicensePlateNumber,
                                                                            child: Text(
                                                                              item
                                                                                  .LicensePlateNumber,
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                              ),
                                                                            ),
                                                                          ))
                                                                          .toList(),
                                                                      validator: (
                                                                          value) {
                                                                        if (value ==
                                                                            null) {
                                                                          return 'Please select vehicle.';
                                                                        }
                                                                      },
                                                                      onChanged: (value) {
                                                                        selectedVehicle = value.toString();
                                                                      },
                                                                      onSaved: (value) {
                                                                        selectedVehicle =
                                                                            value
                                                                                .toString();
                                                                      },
                                                                    ),
                                                                  ),

                                                                ],
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 16, 20, 20),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Expanded(
                                                          child: DropdownButtonFormField2(
                                                            decoration: InputDecoration(
                                                              //Add isDense true and zero Padding.
                                                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.zero,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              //Add more decoration as you want here
                                                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                            ),
                                                            isExpanded: true,
                                                            hint: const Text(
                                                              'Select a service centre.',
                                                              style: TextStyle(fontSize: 14),
                                                            ),
                                                            iconStyleData: const IconStyleData(
                                                              icon : Icon(Icons.arrow_drop_down, color: Colors.black45,),
                                                              iconSize: 30,
                                                            ),
                                                            buttonStyleData: const ButtonStyleData(height : 60, padding: const EdgeInsets.only(left: 20, right: 10)),
                                                            dropdownStyleData : DropdownStyleData(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                            ),
                                                            items: serviceCentres
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
                                                                return 'Please select service centre.';
                                                              }
                                                            },
                                                            onChanged: (value) {
                                                              setState(() {
                                                                if(selectedServiceCentre == false){
                                                                  selectedServiceCentre = !selectedServiceCentre;
                                                                }
                                                                serviceCentreSelectedValue = value.toString();
                                                              });
                                                            },
                                                            onSaved: (value) {

                                                            },
                                                          )
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
                                                Visibility(
                                                  visible: selectedServiceCentre,
                                                  child: FutureBuilder<List<offDays>>(
                                                      future: getAllOffDays(serviceCentreSelectedValue),
                                                      builder: (context, snapshot){
                                                        if(snapshot.hasData){
                                                          if(serviceCentreOffDays.length <= 0){
                                                            serviceCentreOffDays = snapshot.data!;
                                                          }

                                                          if(DisallowedDates.length <= 0){
                                                            for(offDays obj in serviceCentreOffDays){
                                                              DateTime dt = DateTime(obj.date.toDate().year, obj.date.toDate().month, obj.date.toDate().day);
                                                              DisallowedDates.add(dt);
                                                            }
                                                          }
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(20, 16, 20, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: TextField(
                                                                    controller: serviceDateController,
                                                                    obscureText: false,
                                                                    decoration: InputDecoration(
                                                                      labelText: "Service Date",
                                                                      labelStyle: TextStyle(
                                                                        fontSize: 16,
                                                                        fontFamily: 'Louis',
                                                                        color: Color(0xFF95A1AC),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFFDBE2E7),
                                                                          width: 2,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(8),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFFDBE2E7),
                                                                          width: 2,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(8),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: Colors.white70,
                                                                      contentPadding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          16, 24, 0, 24),
                                                                    ),
                                                                    readOnly: true,
                                                                    onTap: () async {
                                                                      for(DateTime dt in DisallowedDates){
                                                                        if(today == dt){
                                                                          if(isTodayOffDay == false){
                                                                            isTodayOffDay = !isTodayOffDay;
                                                                          }
                                                                        }
                                                                      }
                                                                      if(isTodayOffDay == true){
                                                                        DateTime? pickedDate = await showDatePicker(
                                                                            context: context,
                                                                            initialDate: DateTime.now().add(Duration(days: 1)),
                                                                            firstDate: DateTime.now().add(Duration(days: 1)),
                                                                            lastDate: DateTime.now().add(Duration(days: 3650)),
                                                                            selectableDayPredicate: (DateTime date) {
                                                                              return !DisallowedDates.contains(date);
                                                                            }
                                                                        );
                                                                        if (pickedDate != null) {
                                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                                          setState(() {
                                                                            serviceDateController.text = formattedDate;
                                                                            if(selectedServiceDate == false){
                                                                              selectedServiceDate = !selectedServiceDate;
                                                                            }
                                                                            isTodayOffDay = !isTodayOffDay;
                                                                          });
                                                                        }
                                                                        else {
                                                                          print(
                                                                              'Date is not selected');
                                                                        }
                                                                      }
                                                                      else{
                                                                        DateTime? pickedDate = await showDatePicker(
                                                                            context: context,
                                                                            initialDate: DateTime.now(),
                                                                            firstDate: DateTime.now(),
                                                                            lastDate: DateTime.now().add(Duration(days: 3650)),
                                                                            selectableDayPredicate: (DateTime date) {
                                                                              return !DisallowedDates.contains(date);
                                                                            }
                                                                        );
                                                                        if (pickedDate != null) {
                                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                                          setState(() {
                                                                            serviceDateController.text = formattedDate;
                                                                            if(selectedServiceDate == false){
                                                                              selectedServiceDate = !selectedServiceDate;
                                                                            }
                                                                            isTodayOffDay = !isTodayOffDay;
                                                                          });
                                                                        }
                                                                        else {
                                                                          print(
                                                                              'Date is not selected');
                                                                        }
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
                                                Visibility(
                                                  visible: selectedServiceDate,
                                                  child: FutureBuilder<List<String>>(
                                                    future: getAllAvailableTimeSlotsTimeOnly(),
                                                    builder: (context, snapshot){
                                                      if(snapshot.hasData){
                                                        AllowedTime = snapshot.data!;
                                                        if(AllowedTime.length > 0){
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(20, 16, 20, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: DropdownButtonFormField2(
                                                                    decoration: InputDecoration(
                                                                      //Add isDense true and zero Padding.
                                                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                      isDense: true,
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                      //Add more decoration as you want here
                                                                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                    ),
                                                                    isExpanded: true,
                                                                    hint: const Text(
                                                                      'Select Your TimeSlot',
                                                                      style: TextStyle(
                                                                          fontSize: 14),
                                                                    ),
                                                                    iconStyleData: const IconStyleData(
                                                                      icon: Icon(
                                                                        Icons.arrow_drop_down,
                                                                        color: Colors.black45,),
                                                                      iconSize: 30,
                                                                    ),
                                                                    buttonStyleData: const ButtonStyleData(
                                                                        height: 60,
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 20, right: 10)),
                                                                    dropdownStyleData: DropdownStyleData(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                    ),
                                                                    items: AllowedTime
                                                                        .map((item) =>
                                                                        DropdownMenuItem<String>(
                                                                          value: item,
                                                                          child: Text(
                                                                            item,
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ))
                                                                        .toList(),
                                                                    validator: (value) {
                                                                      if (value == null) {
                                                                        return 'Please select time slot.';
                                                                      }
                                                                    },
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        selectedTime = value.toString();
                                                                        if(selectedServiceTimeSlot == false){
                                                                          selectedServiceTimeSlot = !selectedServiceTimeSlot;
                                                                        }
                                                                        //reset everytime selected new timeslot
                                                                        isInMinorOnly = false;
                                                                        isInMajorAndMinor = false;
                                                                        isInMajorAndMinorExtra = false;
                                                                        //call a function
                                                                        String dateAndTime = '${serviceDateController.text.trim()} ${selectedTime.trim()}';
                                                                        DateTime datetime = DateTime.parse(dateAndTime);
                                                                        Timestamp timestamp = Timestamp.fromDate(datetime);
                                                                        assignTimeSlot(timestamp);
                                                                      });

                                                                    },
                                                                    onSaved: (value) {

                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                        else{
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(20, 16, 20, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: FormField(
                                                                    enabled: false,
                                                                    builder: (FormFieldState state) {
                                                                      return DropdownButtonFormField2(
                                                                        decoration: InputDecoration(
                                                                          //Add isDense true and zero Padding.
                                                                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                          isDense: true,
                                                                          contentPadding: EdgeInsets
                                                                              .zero,
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(15),
                                                                          ),
                                                                          //Add more decoration as you want here
                                                                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                        ),
                                                                        isExpanded: true,
                                                                        hint: const Text(
                                                                          'No TimeSlot Available',
                                                                          style: TextStyle(
                                                                              fontSize: 14),
                                                                        ),
                                                                        iconStyleData: const IconStyleData(
                                                                          icon: Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color: Colors.black45,),
                                                                          iconSize: 30,
                                                                        ),
                                                                        buttonStyleData: const ButtonStyleData(
                                                                            height: 60,
                                                                            padding: const EdgeInsets
                                                                                .only(
                                                                                left: 20, right: 10)),
                                                                        dropdownStyleData: DropdownStyleData(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius
                                                                                .circular(15),
                                                                          ),
                                                                        ),
                                                                        items: AllowedTime
                                                                            .map((item) =>
                                                                            DropdownMenuItem<String>(
                                                                              value: item,
                                                                              child: Text(
                                                                                item,
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            ))
                                                                            .toList(),
                                                                        validator: (value) {
                                                                          if (value == null) {
                                                                            return 'Please select time slot.';
                                                                          }
                                                                        },
                                                                        onChanged: (value) {
                                                                          selectedTime = value.toString();
                                                                        },
                                                                        onSaved: (value) {

                                                                        },
                                                                      );
                                                                    },
                                                                  ),

                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }

                                                      } else if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return Center(child: CircularProgressIndicator());
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: selectedServiceTimeSlot,
                                                  child: FutureBuilder<List<String>>(
                                                    future: getAvailableServiceType(),
                                                    builder: (context, snapshot) {
                                                      if(snapshot.hasData){
                                                        serviceTypeAvailable = snapshot.data!;
                                                        if(serviceTypeAvailable.length > 0){
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(20, 16, 20, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: DropdownButtonFormField2(
                                                                    decoration: InputDecoration(
                                                                      //Add isDense true and zero Padding.
                                                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                      isDense: true,
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                      //Add more decoration as you want here
                                                                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                    ),
                                                                    isExpanded: true,
                                                                    hint: const Text(
                                                                      'Select Your Service Type',
                                                                      style: TextStyle(
                                                                          fontSize: 14),
                                                                    ),
                                                                    iconStyleData: const IconStyleData(
                                                                      icon: Icon(
                                                                        Icons.arrow_drop_down,
                                                                        color: Colors.black45,),
                                                                      iconSize: 30,
                                                                    ),
                                                                    buttonStyleData: const ButtonStyleData(
                                                                        height: 60,
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 20, right: 10)),
                                                                    dropdownStyleData: DropdownStyleData(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                    ),
                                                                    items: serviceTypeAvailable
                                                                        .map((item) =>
                                                                        DropdownMenuItem<String>(
                                                                          value: item,
                                                                          child: Text(
                                                                            item,
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

                                                                      selectedValue =
                                                                          value.toString();
                                                                    },
                                                                    onSaved: (value) {

                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }else{
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(20, 16, 20, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: DropdownButtonFormField2(
                                                                    decoration: InputDecoration(
                                                                      //Add isDense true and zero Padding.
                                                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                                      isDense: true,
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                      //Add more decoration as you want here
                                                                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                                                    ),
                                                                    isExpanded: true,
                                                                    hint: const Text(
                                                                      'Sorry, services are full in the chosen slot!',
                                                                      style: TextStyle(
                                                                          fontSize: 14),
                                                                    ),
                                                                    iconStyleData: const IconStyleData(
                                                                      icon: Icon(
                                                                        Icons.arrow_drop_down,
                                                                        color: Colors.black45,),
                                                                      iconSize: 30,
                                                                    ),
                                                                    buttonStyleData: const ButtonStyleData(
                                                                        height: 60,
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 20, right: 10)),
                                                                    dropdownStyleData: DropdownStyleData(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(15),
                                                                      ),
                                                                    ),
                                                                    items: serviceTypeAvailable
                                                                        .map((item) =>
                                                                        DropdownMenuItem<String>(
                                                                          value: item,
                                                                          child: Text(
                                                                            item,
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
                                                                      selectedValue =
                                                                          value.toString();
                                                                    },
                                                                    onSaved: (value) {

                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      } else if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return Center(child: CircularProgressIndicator());
                                                      }

                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 12, 20, 16),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async
                                                        {
                                                          if(addBookingFormKey.currentState!.validate()){
                                                            print('im here');
                                                            addBookingFormKey.currentState!.save();
                                                            await addBooking();
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
                                                          "Book now!",
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontFamily: 'Louis',
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        style: ButtonStyle(
                                                          minimumSize: null,
                                                          backgroundColor: MaterialStateProperty
                                                              .all<Color>(Colors.cyan),
                                                          foregroundColor: MaterialStateProperty
                                                              .all<Color>(
                                                              Colors.lightBlueAccent),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .transparent)
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

                              }else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          )

                        ),

                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<List<String>> getAvailableServiceType() async {
    List<ServiceBay> serviceBay = await getAllServiceBays();
    List<Employee> employees = await getAllEmployeesInSelectedServiceCentreToList();
    List<ServiceBay> activeServiceBays = [];
    List<bookingObject> servicesInSlot = [];
    List<ServiceBay> minorOnlyServiceBay = [];
    List<ServiceBay> majorAndMinorServiceBay = [];
    List<ServiceBay> majorAndMinorExtraServiceBay = [];
    //check which category of service bay is the timeslot in


    for(ServiceBay sb in serviceBay){
      if(sb.Status.compareTo('Active') == 0){
        activeServiceBays.add(sb);
      }
    }

    if(activeServiceBays.length <= 0){
      return Future.value([]);
    }

    //categories all active service bays to either accept what services on the slot
    for(ServiceBay sb in activeServiceBays){
      // if number of employees less than minimum of the service bay
      if(int.parse(sb.NumberOfEmployees) < int.parse(sb.MinNumberOfEmployees)){
        minorOnlyServiceBay.add(sb);
      }
      else if (int.parse(sb.NumberOfEmployees) >= int.parse(sb.MinNumberOfEmployees) && int.parse(sb.NumberOfEmployees) < int.parse(sb.MaxNumberOfEmployees)){
        // if number of employees is same with min, check for what employees in there to determine can major or not
        bool containSenior = false;
        List<Employee> serviceBayEmployees = [];
        for(Employee emp in employees){
          if(emp.BayInCharge.compareTo(sb.Uid.trim()) == 0){
            serviceBayEmployees.add(emp);
          }
        }
        for(Employee emp in serviceBayEmployees){
          if(emp.Position.compareTo('Senior Mechanic') == 0){
            if(!containSenior){
              containSenior = !containSenior;
            }
          }
        }

        if(containSenior){
          majorAndMinorServiceBay.add(sb);
        }
        else{
          minorOnlyServiceBay.add(sb);
        }
      }
      else if(int.parse(sb.NumberOfEmployees) == int.parse(sb.MaxNumberOfEmployees)){
        // if number of employees is same with max only determine the minor extra, if not just remain normal
        bool containSenior = false;
        List<Employee> serviceBayEmployees = [];
        for(Employee emp in employees){
          if(emp.BayInCharge.compareTo(sb.Uid.trim()) == 0){
            serviceBayEmployees.add(emp);
          }
        }

        for(Employee emp in serviceBayEmployees){
          if(emp.Position.compareTo('Senior Mechanic') == 0){
            if(!containSenior){
              containSenior = !containSenior;
            }
          }
        }

        if(containSenior){
          majorAndMinorExtraServiceBay.add(sb);
        }
        else{
          minorOnlyServiceBay.add(sb);
        }
      }

    }

    print('im here before categorizing isInMinorOnly = ${isInMinorOnly}');
    print('im here before categorizing isInMajorAndMinor = ${isInMajorAndMinor}');
    print('im here before categorizing isInMajorAndMinorExtra = ${isInMajorAndMinorExtra}');
    //loop the categorized servicebays, check which one has the selected timeslot
    if(minorOnlyServiceBay.length > 0){
      print('im here in minor only');
      for(ServiceBay sb in minorOnlyServiceBay){
        List<TimeSlot> dataList = [];
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(sb.Uid.trim()).collection('TimeSlots');
        QuerySnapshot snapshot = await ref.get();
        if(snapshot.docs.length > 0){
          dataList = snapshot.docs.map((doc) => TimeSlot(doc['Time'], doc['TimeEnd'], doc['Status'], doc['Uid'])).toList();
          for(TimeSlot ts in dataList){
            if(ts.Uid.compareTo(selectedTimeSlotUid) == 0){
              if(isInMinorOnly == false){
                isInMinorOnly = !isInMinorOnly;
              }

              selectedServiceBayUid = sb.Uid.trim();
            }
          }
        }
      }
    }

    if(majorAndMinorServiceBay.length > 0){
      print('im here in minor and major only');
      for(ServiceBay sb in majorAndMinorServiceBay){
        List<TimeSlot> dataList = [];
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(sb.Uid.trim()).collection('TimeSlots');
        QuerySnapshot snapshot = await ref.get();
        if(snapshot.docs.length > 0){
          dataList = snapshot.docs.map((doc) => TimeSlot(doc['Time'], doc['TimeEnd'], doc['Status'], doc['Uid'])).toList();
          for(TimeSlot ts in dataList){
            if(ts.Uid.compareTo(selectedTimeSlotUid) == 0){
              if(isInMajorAndMinor == false){
                isInMajorAndMinor = !isInMajorAndMinor;
              }
              selectedServiceBayUid = sb.Uid.trim();
            }
          }
        }
      }
    }

    if(majorAndMinorExtraServiceBay.length > 0){
      print('im here in minor and major extra only');
      for(ServiceBay sb in majorAndMinorExtraServiceBay){
        List<TimeSlot> dataList = [];
        CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(sb.Uid.trim()).collection('TimeSlots');
        QuerySnapshot snapshot = await ref.get();
        if(snapshot.docs.length > 0){
          dataList = snapshot.docs.map((doc) => TimeSlot(doc['Time'], doc['TimeEnd'], doc['Status'], doc['Uid'])).toList();
          for(TimeSlot ts in dataList){
            if(ts.Uid.compareTo(selectedTimeSlotUid) == 0){
              if(isInMajorAndMinorExtra == false){
                isInMajorAndMinorExtra = !isInMajorAndMinorExtra;
              }
              selectedServiceBayUid = sb.Uid.trim();
            }
          }
        }
      }
    }

    //after knowing the selected time slot is in which category of service bay, get the servicing list of the timeslot and determine the service available
    if(isInMinorOnly){
      int MinorCount = 0;
      int MajorCount = 0;
      List<bookingObject> services = [];
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snapshot = await ref.get();
      if(snapshot.docs.length > 0){
        services = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for(bookingObject obj in services){
          if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
            MinorCount++;
          }
          else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
            MajorCount++;
          }
        }
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          return Future.value([]);
        }
        else if(MinorCount > 0){
          if(MinorCount < 2){
            List<String> serviceTypeItems = [
              'Minor(normal service)',
            ];
            return Future.value(serviceTypeItems);
          }
          else{
            return Future.value([]);
          }
        }
      }
      else{
        List<String> serviceTypeItems = [
          'Minor(normal service)',
        ];
        return Future.value(serviceTypeItems);
      }
    }
    else if(isInMajorAndMinor){
      int MinorCount = 0;
      int MajorCount = 0;
      List<bookingObject> services = [];
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snapshot = await ref.get();
      if(snapshot.docs.length > 0) {
        services = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for (bookingObject obj in services) {
          if (obj.ServiceType.compareTo('Minor(normal service)') == 0) {
            MinorCount++;
          }
          else if (obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0) {
            MajorCount++;
          }
        }
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          return Future.value([]);
        }
        else if(MinorCount > 0){
          if(MinorCount < 2){
            List<String> serviceTypeItems = [
              'Minor(normal service)',
            ];
            return Future.value(serviceTypeItems);
          }
          else{
            return Future.value([]);
          }
        }
      }else{
        List<String> serviceTypeItems = [
          'Major(Recommended: once every 2 years)',
          'Minor(normal service)',
        ];
        return Future.value(serviceTypeItems);
      }
    }
    else if(isInMajorAndMinorExtra){
      int MinorCount = 0;
      int MajorCount = 0;
      List<bookingObject> services = [];
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snapshot = await ref.get();
      if(snapshot.docs.length > 0) {
        services = snapshot.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for (bookingObject obj in services) {
          if (obj.ServiceType.compareTo('Minor(normal service)') == 0) {
            MinorCount++;
          }
          else if (obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0) {
            MajorCount++;
          }
        }
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          if(MinorCount > 0){
            return Future.value([]);
          }else{
            List<String> serviceTypeItems = [
              'Minor(normal service)',
            ];
            return Future.value(serviceTypeItems);
          }
        }
        else if(MinorCount > 0){
          if(MinorCount < 3){
            List<String> serviceTypeItems = [
              'Minor(normal service)',
            ];
            return Future.value(serviceTypeItems);
          }
          else{
            return Future.value([]);
          }
        }
      }else{
        List<String> serviceTypeItems = [
          'Major(Recommended: once every 2 years)',
          'Minor(normal service)',
        ];
        return Future.value(serviceTypeItems);
      }
    }

    return Future.value([]);

  }

  Future<List<vehicleObject>> getAllVehiclesToList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<vehicleObject> dataList = [];
      dataList = snapshot.docs.map((doc) => vehicleObject(doc['NRIC'], doc['Model'], doc['Brand'], doc['Condition'], doc['LicensePlateNumber'], doc['Status'], doc['Uid'])).toList();
      if(dataList.length > 0){
        List<vehicleObject> vehiclesConfirmed = [];
        for(vehicleObject obj in dataList){
          if(obj.Status.compareTo('Confirmed') == 0){
            vehiclesConfirmed.add(obj);
          }
        }
        return Future.value(vehiclesConfirmed);
      }
    }
    return Future.value([]);

  }

  Future<List<Employee>> getAllEmployeesInSelectedServiceCentreToList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('Employees');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<Employee> dataList = [];
      dataList = snapshot.docs.map((doc) => Employee(doc['BayInCharge'], doc['NRIC'], doc['Name'], doc['Position'], doc['Salary'], doc['WorkStatus'], doc['Uid'], doc['email'], doc['password'])).toList();
      if(dataList.length > 0){
        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

  Future<List<serviceCentre>> getAllServiceCentres() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<serviceCentre> dataList = [];
      dataList = snapshot.docs.map((doc) => serviceCentre(doc['Name'], doc['State'], doc['City'], doc['Street'], doc['Postcode'], doc['Uid'], doc['ContactNumber'])).toList();
      if(dataList.length > 0){

        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

  Future<List<offDays>> getAllOffDays(String serviceCentreName) async {
    String state = '';
    String uid = '';
    for(serviceCentre svc in serviceCentres){
      if(svc.Name.compareTo(serviceCentreName) == 0){
        state = svc.State;
      }
    }
    CollectionReference ref = FirebaseFirestore.instance.collection('PublicHolidays2023');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<StatePbDate> dataList = [];
      dataList = snapshot.docs.map((doc) => StatePbDate(doc['State'], doc['Uid'])).toList();
      if(dataList.length > 0){
        for(StatePbDate obj in dataList){
          if(obj.State.compareTo(state) == 0){
            uid = obj.Uid;
          }

        }
        CollectionReference datesRef = FirebaseFirestore.instance.collection('PublicHolidays2023').doc(uid.trim()).collection('Dates');
        QuerySnapshot datesSnapshot = await datesRef.get();
        if(datesSnapshot.docs.length>0){
          List<offDays> dataList = [];
          dataList = datesSnapshot.docs.map((doc) => offDays(doc['Date'])).toList();
          if(dataList.length > 0){
            return Future.value(dataList);
          }
        }
      }
    }
    return Future.value([]);

  }

  // addbooking needs to check for timeslot availability first(check the max and status ), then
  Future<void> addBooking() async {
    DocumentReference newVehicleRef = FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('vehicle').doc();
    String uid = newVehicleRef.id;
    //selectedTime, serviceDateController.text
    String dateAndTime = '${serviceDateController.text.trim()} ${selectedTime.trim()}';
    DateTime datetime = DateTime.parse(dateAndTime);
    Timestamp timestamp = Timestamp.fromDate(datetime);
    Timestamp time = Timestamp.fromDate(DateTime.now());

    //set in user booking table
    await FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).collection('booking').doc(uid).set({
      "ServiceCentreName" : serviceCentreSelectedValue,
      "LicensePlateNumber" : selectedVehicle,
      "TimeSlot" : timestamp,
      "ServiceType" : selectedValue,
      "Uid" : uid,
      "TimeSlotUid" : selectedTimeSlotUid,
      "ServiceBayUid" : selectedServiceBayUid,
      "ServiceCentreUid" : selectedServiceCentreUid,
      "Status" : 'New',
      "LastUpdatedTime" : time
    }).catchError((error) {
      print(error.toString());
    });

    //set in service centre timeslots
    await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList').doc(uid).set(
      {
        "ServiceCentreName" : serviceCentreSelectedValue,
        "LicensePlateNumber" : selectedVehicle,
        "TimeSlot" : timestamp,
        "ServiceType" : selectedValue,
        "Uid" : uid,
        "TimeSlotUid" : selectedTimeSlotUid,
        "ServiceBayUid" : selectedServiceBayUid,
        "ServiceCentreUid" : selectedServiceCentreUid,
        "Status" : 'New',
        "LastUpdatedTime" : time
      }
    ).catchError((error) {
      print(error.toString());
    });

    //reassign timeslot availability
    if(isInMinorOnly == true){
      int MinorCount = 0;
      int MajorCount = 0;
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snap = await ref.get();
      List<bookingObject> services = [];
      if(snap.docs.length > 0){
        services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for(bookingObject obj in services){
          if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
            MinorCount++;
          }
          else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
            MajorCount++;
          }
        }
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
            "Status" : 'Full'
          }).catchError((error) {
            print(error);
          });
        }
        else if(MinorCount > 0){
          if(MinorCount >= 2){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
        }
      }
    }
    else if(isInMajorAndMinor == true){
      int MinorCount = 0;
      int MajorCount = 0;
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snap = await ref.get();
      List<bookingObject> services = [];
      if(snap.docs.length > 0){
        services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for(bookingObject obj in services){
          if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
            MinorCount++;
          }
          else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
            MajorCount++;
          }
        }

        print('im here to check if MajorCount is = ${MajorCount}');
        print('im here to check if MinorCount is = ${MinorCount}');
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
            "Status" : 'Full'
          }).catchError((error) {
            print(error);
          });
        }
        else if(MinorCount > 0){
          if(MinorCount >= 2){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
        }
      }
    }
    else if(isInMajorAndMinorExtra == true){
      int MinorCount = 0;
      int MajorCount = 0;
      CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).collection('ServicingList');
      QuerySnapshot snap = await ref.get();
      List<bookingObject> services = [];
      if(snap.docs.length > 0){
        services = snap.docs.map((doc) => bookingObject(doc['ServiceCentreName'], doc['TimeSlot'], doc['LicensePlateNumber'], doc['ServiceType'], doc['Uid'], doc['Status'], doc['TimeSlotUid'], doc['ServiceBayUid'], doc['ServiceCentreUid'], doc['LastUpdatedTime'])).toList();
        for(bookingObject obj in services){
          if(obj.ServiceType.compareTo('Minor(normal service)') == 0){
            MinorCount++;
          }
          else if(obj.ServiceType.compareTo('Major(Recommended: once every 2 years)') == 0){
            MajorCount++;
          }
        }
        // check the timeslot servicing list have major or not, if have straight return no other services
        if(MajorCount > 0){
          await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
            "Status" : 'Full'
          }).catchError((error) {
            print(error);
          });
        }
        else if(MinorCount > 0){
          if(MinorCount >= 3){
            await FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay').doc(selectedServiceBayUid.trim()).collection('TimeSlots').doc(selectedTimeSlotUid.trim()).update({
              "Status" : 'Full'
            }).catchError((error) {
              print(error);
            });
          }
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booked Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) =>MyHomePage(title: 'Home')), (route) => false);

  }

  Future<List<ServiceBay>> getAllServiceBays() async {
    for(serviceCentre obj in serviceCentres){
      if(obj.Name.compareTo(serviceCentreSelectedValue) == 0){
        selectedServiceCentreUid = obj.Uid;
      }
    }
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length>0){
      List<ServiceBay> dataList = [];
      dataList = snapshot.docs.map((doc) => ServiceBay(doc['Name'], doc['NumberOfEmployees'], doc['Occupancy'], doc['Status'], doc['Uid'], doc['MaxNumberOfEmployees'], doc['MinNumberOfEmployees'])).toList();
      if(dataList.length > 0){

        return Future.value(dataList);
      }
    }
    return Future.value([]);

  }

  Future<List<TimeSlot>> getAllTimeSlots() async {
    List<ServiceBay> ServiceBays = await getAllServiceBays();
    List<ServiceBay> ActiveServiceBays = [];
    List<TimeSlot> timeSlots = [];
    List<TimeSlot> availableTimeSlots = [];
    List<TimeSlot> availableTimeSlotsOnSelectedDate = [];
    String selectedDate = serviceDateController.text;
    DateTime selectedDateInDateTime = DateTime.parse(selectedDate.trim());
    CollectionReference ref = FirebaseFirestore.instance.collection('ServiceCentre').doc(selectedServiceCentreUid.trim()).collection('ServiceBay');
    print('ServiceBays length =  ${ServiceBays.length}');
    for(ServiceBay svb in ServiceBays){
      if(svb.Status.compareTo('Active') == 0){
        ActiveServiceBays.add(svb);
      }
    }

    if(ActiveServiceBays.length <= 0){
      return Future.value([]);
    }

    // get all timeslots of active service bays
    for(ServiceBay svb in ActiveServiceBays){
      QuerySnapshot snapshot = await ref.doc(svb.Uid.trim()).collection('TimeSlots').get();
      List<TimeSlot> dataList = [];
      if(snapshot.docs.length > 0){
        dataList = snapshot.docs.map((doc) => TimeSlot(doc['Time'], doc['TimeEnd'], doc['Status'], doc['Uid'])).toList();
      }
      if(dataList.length > 0){
        for(TimeSlot ts in dataList){
          print(ts.Uid);
          timeSlots.add(ts);
        }
      }
    }

    if(timeSlots.length<=0){
      return Future.value([]);
    }

    // filter only available time slot
    for(TimeSlot ts in timeSlots){
      if(ts.Status.compareTo('Available') == 0){
        availableTimeSlots.add(ts);
      }
    }

    if(availableTimeSlots.length <= 0){
      return Future.value([]);
    }

    for(TimeSlot ts in availableTimeSlots){
      chosenServiceCentreAvailableTimeSlots.add(ts);
    }

    for(TimeSlot ts in availableTimeSlots){
      DateTime dateOnly = DateTime(ts.Time.toDate().year, ts.Time.toDate().month, ts.Time.toDate().day);
      if(dateOnly == selectedDateInDateTime){
        availableTimeSlotsOnSelectedDate.add(ts);
      }
    }

    if(availableTimeSlotsOnSelectedDate.length > 0){
      return Future.value(availableTimeSlotsOnSelectedDate);
    }
    else{
      return Future.value([]);
    }



  }

  Future<List<String>> getAllAvailableTimeSlotsTimeOnly() async {
    List<TimeSlot> timeSlots = await getAllTimeSlots();
    if(timeSlots.length > 0){
      List<String> timeInString = [];
      for(TimeSlot ts in timeSlots){
        DateTime timeOnly = DateTime(0,0,0,ts.Time.toDate().hour, ts.Time.toDate().minute, ts.Time.toDate().second);
        String time = DateFormat('HH:mm:ss').format(timeOnly);
        timeInString.add(time);
      }

      return Future.value(timeInString.toSet().toList());
    }
    return Future.value([]);

  }

  void assignTimeSlot(Timestamp dateTime) {
    List<TimeSlot> timeSlot = [];
    for(TimeSlot ts in chosenServiceCentreAvailableTimeSlots){
      DateTime dt = DateTime(ts.Time.toDate().year, ts.Time.toDate().month, ts.Time.toDate().day, ts.Time.toDate().hour, ts.Time.toDate().minute, ts.Time.toDate().second);
      if(dt == dateTime.toDate()){
        timeSlot.add(ts);
      }
    }

    if(timeSlot.length>1){
      timeSlot.shuffle();
      selectedTimeSlotUid = timeSlot.first.Uid;
    }
    else{
      selectedTimeSlotUid = timeSlot.first.Uid;
    }
  }

}
