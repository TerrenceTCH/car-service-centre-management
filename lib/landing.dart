import 'package:car_service_management_application/loginPage.dart';
import 'package:car_service_management_application/main.dart';
import 'package:car_service_management_application/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'homePage.dart';

class landingPage extends StatefulWidget {
  const landingPage({Key? key}) : super(key: key);

  @override
  State<landingPage> createState() => _landingState();
}

class _landingState extends State<landingPage> {
  final List<String> imgList = [
    'https://previews.123rf.com/images/bialasiewicz/bialasiewicz1404/bialasiewicz140400744/27655385-mechanic-fixing-car-engine-with-key-vertical.jpg?fj=1',
    'https://www.nahrin.com/nahrin/images/partnership/distibutor/image-thumb__142__teaser_colorbox/distribution-partnership-learn-more-adobestock_223514811_preview.jpg',
  ];

  void _loginPressed(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginPage()), (route) => false);
  }

  void _registerPressed(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => registerPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders =
    imgList.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0,),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      'Car Days Service Application',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.cyanAccent, Colors.blueAccent])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                        child: Text("Car Days Application", style: TextStyle(fontSize: 20, fontFamily: 'Louis', color: Colors.transparent)),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 2.3,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 2,
                      autoPlay: true,
                    ),
                    items: imageSliders,
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 80, 5, 20),
                              child: Text("A brand new Experience on your" + "\n" +  "car servicing progress!",textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontFamily: 'Louis', color: Colors.white, )),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
                          child: ElevatedButton(
                            child: Text(
                              "Hop on the Journey!",
                              style: TextStyle(fontSize: 15, fontFamily: 'Louis', color: Colors.black87),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Colors.blueGrey)
                                ),
                              ),
                            ),
                            onPressed: _registerPressed,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: ElevatedButton(
                            child: Text(
                              "Already on the Journey?",
                              style: TextStyle(fontSize: 15, fontFamily: 'Louis', color: Colors.white70),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Colors.blueGrey)
                                ),
                              ),
                            ),
                            onPressed: _loginPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );

  }

}