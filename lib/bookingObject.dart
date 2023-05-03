import 'package:cloud_firestore/cloud_firestore.dart';

class bookingObject {
  String ServiceCentreName;
  Timestamp TimeSlot;
  String LicensePlateNumber;
  String ServiceType;
  String Uid;
  String Status;
  String TimeSlotUid;
  String ServiceBayUid;
  String ServiceCentreUid;
  Timestamp LastUpdatedTime;

  bookingObject(this.ServiceCentreName, this.TimeSlot, this.LicensePlateNumber, this.ServiceType, this.Uid, this.Status, this.TimeSlotUid, this.ServiceBayUid, this.ServiceCentreUid, this.LastUpdatedTime);

}