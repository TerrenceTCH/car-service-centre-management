import 'package:car_service_management_application/landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:car_service_management_application/feature.dart';
import 'package:car_service_management_application/homePage.dart';
import 'package:car_service_management_application/contactUs.dart';
import 'package:car_service_management_application/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_service_management_application/user.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Widget home;
    if(firebaseUser != null){
      home = MyHomePage(title: 'CarDays');
    }else{
      home = landingPage();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarDays',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: home,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final int landingIndex = 0;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _currIndex = 0;

  List<Widget> _children() => [
    homePage(),
    featurePlace(),
    profilePage(),
  ];

  void onTappedBar(int index){
    setState((){
      _currIndex = index;
    });

  }

  Future<Users?> readUser(String? id) async{
    final userdoc = FirebaseFirestore.instance.collection('users').doc(id.toString());
    final snapshot = await userdoc.get();
    
    if(snapshot.exists){
      return Users.fromJson(snapshot.data()!);
    }

  }

  void _testPressed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => featurePlace()));
  }

  @override
  Widget build(BuildContext context) {
    final _controller = PageController(initialPage: 0);
    final List<Widget> children = _children();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<Users?>(
            future: readUser(auth.currentUser?.uid),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                print(snapshot.error.toString());
                return Text('Something went wrong!');
              }
              if(snapshot.hasData){
                final user = snapshot.data;

                return Text('Hello ${user?.name}' , style: TextStyle(fontFamily: 'Louis', fontSize: 25, color: Colors.black),);
              }
              else{
                return Center(
                  child: CircularProgressIndicator(

                  ),
                );
              }
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          shadowColor: Colors.transparent,
        ),
        body: PageView(
          controller: _controller,
          onPageChanged: (index){
            setState(() {
              onTappedBar(index);
            });
          },
          children: _children(),
        ),
        //children[_currIndex],
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home_filled, title: 'Home'),
            TabItem(icon: Icons.bolt_sharp, title: 'Feature'),
            TabItem(icon: Icons.menu, title: 'Profile'),
          ],
          color: Colors.black87,
          backgroundColor: Colors.blueAccent,
          activeColor: Colors.white,
          initialActiveIndex: 0,
          onTap: (int index) {
            onTappedBar(index);
            _controller.animateToPage(
                index,
                duration: Duration(milliseconds: 450),
                curve: Curves.easeInOut
            );
          },
        )
      ),

    );
  }
}
