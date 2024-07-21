import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/mudeuls/chat/chat_screen.dart';
import 'package:snaapro/mudeuls/home/home_page.dart';
import 'package:snaapro/mudeuls/search_screen/search_page.dart';
import 'package:snaapro/mudeuls/user/user_page.dart';

import '../../mudeuls/setting_page/setting_page.dart';

class HomeLayout extends StatefulWidget {
  //final String username;
  //inal String job;
  //final String city;
  //{ required this.username, required this.job, required this.city}
  HomeLayout();

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  // final GlobalKey<DrawerControllerState> _drawerKey =
  // GlobalKey<DrawerControllerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentindex = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String? email = FirebaseAuth.instance.currentUser!.email;
  QueryDocumentSnapshot? userid;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    data.addAll(querySnapshot.docs);
    setState(() {});
    querySnapshot.docs.forEach((doc) {
      if (doc['email'] == email) userid ??= doc;
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  late List screens = [
    UserPage(
      //username:userid?['name'],job:userid?['job'],city:userid?['city'],userid: userid,
    ),

    SettingPage(),
    SearchPage(),
    ChatsScreen(),
    HomePage(),
  ];
  List<String> label = [
    'home',
    'setting',
    'search',
    'Messanger',
    'user',
  ];

  Color c = Color.fromRGBO(255, 116, 49, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 15.0,
        showSelectedLabels: false,
        currentIndex: currentindex,
        onTap: (index) {
          //if(currentindex==1)  _scaffoldKey.currentState?.openDrawer();
          setState(() {
            currentindex = index;

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'user',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              // color:c,
            ),
            label: 'setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              // color: c,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              // color: c,
            ),
            label: 'Messanger',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              // color: c
            ),
            label: 'home',
          ),
        ],
      ),
    );
  }
}
