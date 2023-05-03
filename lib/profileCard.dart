import 'package:car_service_management_application/user.dart';
import 'package:flutter/material.dart';


class ProfileCard extends StatelessWidget {
  final Users _profile;

  ProfileCard(this._profile);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('${_profile.name}'),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('NRIC: ${_profile.NRIC}'),
            ),
          ),
        ),
      ),
    );
  }
}
