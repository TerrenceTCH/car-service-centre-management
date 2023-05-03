import 'package:car_service_management_application/serviceCentre.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contactCard extends StatelessWidget {
  final serviceCentre _serviceCentre;

  contactCard(this._serviceCentre);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('${_serviceCentre.Name}'),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Contact Number: ${_serviceCentre.ContactNumber}'),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: _serviceCentre.ContactNumber,
              );
              await launchUrl(launchUri);
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => bookingDetails(booking: _booking)));
            },
          ),
        ),
      ),
    );
  }

}
