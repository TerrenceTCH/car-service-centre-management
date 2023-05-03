import 'package:car_service_management_application/vehicleDetails.dart';
import 'package:car_service_management_application/vehicleObject.dart';
import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final vehicleObject _vehicle;

  VehicleCard(this._vehicle);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('${_vehicle.LicensePlateNumber}'),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('${_vehicle.Brand} ${_vehicle.Model} --> Status: ${_vehicle.Status}'),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              if(_vehicle.Status != 'In Service'){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleDetails(vehicle: _vehicle)));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vehicle is In Service!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }

            },
          ),
        ),
      ),
    );
  }
}
