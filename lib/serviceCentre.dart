import 'package:cloud_firestore/cloud_firestore.dart';

class serviceCentre{
  String Name;
  String State;
  String City;
  String Street;
  String Postcode;
  String Uid;
  String ContactNumber;

  serviceCentre(this.Name, this.State, this.City, this.Street, this.Postcode, this.Uid, this.ContactNumber);
}

class offDays {
  Timestamp date;

  offDays(this.date);
}

class StatePbDate{
  String State;
  String Uid;

  StatePbDate(this.State, this.Uid);
}

class ServiceBay {
  String Name;
  String NumberOfEmployees;
  String Occupancy;
  String Status;
  String Uid;
  String MaxNumberOfEmployees;
  String MinNumberOfEmployees;

  ServiceBay(this.Name, this.NumberOfEmployees, this.Occupancy, this.Status, this.Uid, this.MaxNumberOfEmployees, this.MinNumberOfEmployees);
}

class TimeSlot{
  Timestamp Time;
  Timestamp TimeEnd;
  String Status;
  String Uid;

  TimeSlot(this.Time, this.TimeEnd, this.Status, this.Uid);

  factory TimeSlot.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return TimeSlot(
      data['Time'],
      data['TimeEnd'],
      data['Status'],
      data['Uid']
    );
  }
}

class Employee{
  String BayInCharge;
  String NRIC;
  String Name;
  String Position;
  String Salary;
  String WorkStatus;
  String Uid;
  String email;
  String password;

  Employee(this.BayInCharge, this.NRIC, this.Name, this.Position, this.Salary, this.WorkStatus, this.Uid, this.email, this.password);
}