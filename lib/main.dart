import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/layout/home_layout/home_layout.dart';
import 'package:snaapro/mudeuls/firstPage/firstPage.dart';

import 'mudeuls/admin_screen/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDpC_1hztcZe2gLK7XUvP0LIIIa2lvzT4I',
      appId: '1:804341612631:android:c9a6c270a7b73a7a852312',
      projectId: 'sanaa-704e9',
      storageBucket: 'sanaa-704e9.appspot.com',
      messagingSenderId: '804341612631',
      authDomain: 'sanaa-704e9.firebaseapp.com',
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          elevation: 20.0,
        ),
      ),
      home: AnimatedSplashScreen(
        splash: 'images/Untitled-1.png',
        splashIconSize: 200.0,
        duration: 3000,
        backgroundColor: Colors.white,
        nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return snapshot.hasData
                  ? FutureBuilder<bool>(
                future: isEmailExists(FirebaseAuth.instance.currentUser!.email),
                builder: (context, emailSnapshot) {
                  if (emailSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    bool emailExists = emailSnapshot.data ?? false;
                    return emailExists ? HomeLayout() : AdminPge();
                  }
                },
              )
                  : firstPage();
            }
          },
        ),
      ),
    );
  }

  Future<bool> isEmailExists(String? email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }
}
