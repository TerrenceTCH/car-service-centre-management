import 'package:car_service_management_application/BookingStatus.dart';
import 'package:car_service_management_application/bookingDetails.dart';
import 'package:car_service_management_application/bookingObject.dart';
import 'package:car_service_management_application/serviceCentre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class bookingCard extends StatelessWidget {
  final bookingObject _booking;
  int statusListLength = 0;
  String estimated = '';


  bookingCard(this._booking);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Car plate number: ${_booking.LicensePlateNumber}'),
            ),
            subtitle: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('${_booking.TimeSlot.toDate().toString()} -> ${_booking.ServiceCentreName}'),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('0%'),
                        Text('100%'),
                      ],
                    ),
                    FutureBuilder<BookingStatus?>(
                      future: getPercentage(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          BookingStatus status = snapshot.data!;
                          double percentage = int.parse(status.Indicator) / statusListLength;
                          print(snapshot.data);
                          return Column(
                            children: <Widget>[
                              LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                value: percentage,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2, 5, 0, 5),
                                      child: Text('Status:'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 5),
                                      child: Text('${status.Status}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0,5,0,5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2, 5, 0, 5),
                                      child: Text('${status.Description}'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 5),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(2, 5, 0, 5),
                                            child: Text('Estimated Time:'),
                                          ),
                                          FutureBuilder<String>(
                                            future: getEstimatedTime(),
                                            builder: (context, snapshot){
                                              if(snapshot.hasData){
                                                estimated = snapshot.data!;
                                                return Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(2, 5, 0, 5),
                                                  child: Text(estimated),
                                                );
                                              }
                                              else if (snapshot.hasError) {
                                                print(snapshot.data);
                                                return Text('Error: ${snapshot.error}');
                                              } else {
                                                return Center(child: CircularProgressIndicator());
                                              }
                                            },
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0,5,0,5),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(2, 5, 0, 5),
                                  child: Text('LastUpdatedTime ${_booking.LastUpdatedTime.toDate()}'),
                                ),
                              ),

                            ],
                          );

                        }else if (snapshot.hasError) {
                          print(snapshot.data);
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                    ),

                  ],
                ),

              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              if(_booking.Status.compareTo('New') == 0){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => bookingDetails(booking: _booking)));
              }
              else{
                AlertDialog(
                  title: Text("Unable to update"),
                  content: Text("The selected booking is either finished or ongoing servicing. Therefore unable to update."),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),

      ),
    );
  }

  Future<BookingStatus?> getPercentage() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('BookingStatus');
    QuerySnapshot snapshot = await ref.get();
    if(snapshot.docs.length > 0){
      List<BookingStatus> statusList = [];
      statusList = snapshot.docs.map((doc) => BookingStatus(doc['Status'], doc['Description'], doc['Indicator'])).toList();
      for(BookingStatus status in statusList){
        if(_booking.Status.compareTo(status.Status) == 0){

          statusListLength = statusList.length;
          return Future.value(status);

        }
      }
    }
    return Future.value(null);
  }

  Future<String> getEstimatedTime() async{
    DocumentReference reference = FirebaseFirestore.instance.collection('ServiceCentre').doc(_booking.ServiceCentreUid.trim()).collection('ServiceBay').doc(_booking.ServiceBayUid.trim()).collection('TimeSlots').doc(_booking.TimeSlotUid.trim());
    DocumentSnapshot snap = await reference.get();
    if(snap.exists){
      TimeSlot temp = TimeSlot.fromSnapshot(snap);
      print('im here checking temp timeend ${temp.TimeEnd.toDate()}');
      if(temp.TimeEnd.toDate().compareTo(DateTime.now())>0){
        Duration difference = temp.TimeEnd.toDate().difference(DateTime.now());
        int days = difference.inDays;
        int hours = difference.inHours.remainder(24);
        int minutes = difference.inMinutes.remainder(60);
        int seconds = difference.inSeconds.remainder(60);

        if(days > 1){
          return '$days days remaining';
        }
        else if(days == 1){
          return '$days day, $hours hours';
        }
        else if(days < 1){
          return '$hours hours, $minutes minutes, $seconds seconds remaining';
        }

      }
      else{
        return '0 Seconds';

      }
    }
    return '';
  }
}
