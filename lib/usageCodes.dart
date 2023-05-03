// appBar: AppBar(
// toolbarHeight: 100.0,
// backgroundColor: Colors.greenAccent,
// centerTitle: true,
// title: Text('Testing Appbar', style: TextStyle(color: Colors.grey)),
// ),


// Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: NetworkImage('https://drive.google.com/file/d/1SF1EOJ3UaEqrp4SLdMc9UzN82iuoy3ML/view?usp=sharing')
// )
// ),
// ),

// Container(
// child: CarouselSlider(
// options: CarouselOptions(
// height: MediaQuery.of(context).size.height / 2,
// aspectRatio: 2.0,
// enlargeCenterPage: true,
// enableInfiniteScroll: false,
// initialPage: 2,
// autoPlay: true,
// ),
// items: imageSliders,
// ),
// ),

// title: Text(getUserName().toString(), style: TextStyle(color: Colors.black)),
// actions: [
// IconButton(
// onPressed: () async =>{
// await FirebaseAuth.instance.signOut(),
// Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => landingPage()), (route) => false),
// },
// icon: Icon(
// Icons.logout,
// color: Colors.white60,
// ),
// ),
// ],
// flexibleSpace: Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: <Color>[Colors.cyan.shade100, Colors.white60],
// ),
// ),
// ),

// FutureBuilder<Users?>(
// future: readUser(),
// builder: (context, snapshot) {
// if(snapshot.hasData){
// final user = snapshot.data;
// return
// user == null
// ? Center(child: Text('No User')) : homePage(user: user);
// }
// },
// ),

// TextFormField(
// controller: NRICController,
// obscureText: false,
// decoration: InputDecoration(
// labelText: "NRIC No.",
// labelStyle: TextStyle(
// fontSize: 16,
// fontFamily: 'Louis',
// color: Color(0xFF95A1AC),
// ),
// hintText: "Enter your malaysian identity card number here.",
// hintStyle: TextStyle(
// fontSize: 20,
// fontFamily: 'Louis',
// color: Color(0xFF95A1AC),
// ),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Color(0xFFDBE2E7),
// width: 2,
// ),
// borderRadius: BorderRadius.circular(8),
// ),
// focusedBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Color(0xFFDBE2E7),
// width: 2,
// ),
// borderRadius: BorderRadius.circular(8),
// ),
// filled: true,
// fillColor: Colors.white70,
// contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
// ),
// style: TextStyle(
// fontFamily: 'Louis',
// fontSize: 20,
// color: Color(0xFF2B343A),
// ),
// ),