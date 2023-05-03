import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'addVehicle.dart';
class DetectionResult extends StatefulWidget {
  const DetectionResult({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  State<DetectionResult> createState() => _DetectionResultState();
}

class _DetectionResultState extends State<DetectionResult> {
  String? CarPlate;
  @override
  void initState()
  {
    super.initState();
    CarPlate = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              CarPlate!,
              style: TextStyle(
                  fontSize: 50
              ),
            ),
            ElevatedButton(
                onPressed: checkFormat,
                child: Text('Proceed')
            ),
          ],
        ),
      )
    );
  }
  void checkFormat()
  {
    setState(() {
      CarPlate = CarPlate?.trim();
      CarPlate = CarPlate?.toUpperCase();
      CarPlate = CarPlate?.replaceAll(' ', '');
      RegExp licensePattern = RegExp(r'^[a-zA-Z]{1,3}\d{1,4}[a-zA-Z]$');
      _showSuccessDialog(context);

    });
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceed with registration'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Register vehicle with license plate <$CarPlate> .',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) => addVehicle(detectedCarPlate: CarPlate)), (route) => false);
                    // do something when the button is pressed
                  },
                  child: const Text('Click me'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFailDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Detection'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Detected text does not match Car Plate Pattern! Are you sure you wanna proceed?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (content) => addVehicle(detectedCarPlate: CarPlate)), (route) => false);
                      },
                      child: const Text('Yes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // do something when the button is pressed
                      },
                      child: const Text('No'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


