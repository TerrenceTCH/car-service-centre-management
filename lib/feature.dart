
import 'package:car_service_management_application/addVehicle.dart';
import 'package:car_service_management_application/bookingList.dart';
import 'package:car_service_management_application/contactUs.dart';
import 'package:car_service_management_application/detection.dart';
import 'package:flutter/material.dart';

class featurePlace extends StatelessWidget {
  const featurePlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 50),
                child: Text(
                    'Feature Place',
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Daviton',
                    color: Colors.black
                  ),
                ),
              ),
            ),
            Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: ButtonTable(
                    buttonLabels: [
                      ["detection", "contact"],
                      ["addvehicle", "checkbooking"],
                    ],
                    onPressed: (int row, int col){
                      if(row == 0 && col == 0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Detection()),);
                      }
                      else if(row == 0 && col == 1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const contactUs()),);
                      }
                      else if(row == 1 && col == 0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const addVehicle()),);
                      }
                      else if(row == 1 && col == 1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const bookingListPage()),);
                      }
                    },
                  ),
                )
            ),
          ],
        ),

      ),
    );
  }
}

class ButtonTable extends StatelessWidget {
  final List<List<String>> buttonLabels;
  final void Function(int row, int col) onPressed;
  Map<String, IconData> icons = {
    'detection': Icons.camera_alt_outlined,
    'contact': Icons.phone_callback,
    'comingsoon': Icons.star_border,
    'addvehicle': Icons.add,
    'checkbooking': Icons.car_repair,
    'detectionbooking': Icons.camera_alt_outlined,
    // add more mappings here
  };
  Map<String, String> labels = {
    'detection': 'Car Plate Detection',
    'contact': 'Contact us now!',
    'comingsoon': 'Coming soon',
    'addvehicle': 'Add new Vehicle',
    'checkbooking' : 'Check booking',
    'detectionbooking' : 'Check in vehicle'
    // add more mappings here
  };

  ButtonTable({required this.buttonLabels, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.transparent),
      children: buttonLabels.asMap().map((rowIndex, row) {
        return MapEntry(
          rowIndex,
          TableRow(
            children: row.asMap().map((colIndex, label) {
              return MapEntry(
                colIndex,
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.black)
                          ),
                        ),
                      ),
                      onPressed: () {
                        onPressed(rowIndex, colIndex);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Icon(icons[label]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                labels[label]!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).values.toList(),
          ),
        );
      }).values.toList(),
    );
  }
}

