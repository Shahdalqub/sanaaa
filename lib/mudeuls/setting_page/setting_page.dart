import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snaapro/mudeuls/firstPage/firstPage.dart';
import 'package:snaapro/mudeuls/setting_page/Suggestions.dart';
import 'package:snaapro/mudeuls/setting_page/change_name.dart';
import 'package:snaapro/mudeuls/setting_page/change_password.dart';

import 'NotificationPage.dart';
import 'StorageImageView.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _switchValue = false;
  File? _image;
  String? valueChooseJob;
  String? valueChooseCity;
  String? oldJob;
  @override
  void initState() {
    super.initState();
    _countUnreadNotifications();
    _loadSwitchState();
    _getUserEmpty();
    getDataCity();
    getDataJob();
    _getUserJob();
    _notificationCount;
  }

  var listCity = [

  ];
  List<QueryDocumentSnapshot> data = [];
  Future getDataCity() async {
    listCity = [];
    CollectionReference users = FirebaseFirestore.instance.collection('city');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data.add(element);
      listCity.add(element['name']);
    });
    setState(() {});
  }

  List<DropdownMenuItem<String>> _createListCity() {
    return listCity
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          textAlign: TextAlign.right,
        ),
      ),
    )
        .toList();
  }

  List<DropdownMenuItem<String>> _createListJob() {
    return listJob
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          textAlign: TextAlign.right,
        ),
      ),
    )
        .toList();
  }

  var listJob = [];
  List<QueryDocumentSnapshot> data2 = [];
  Future getDataJob() async {
    listJob = [];
    CollectionReference users = FirebaseFirestore.instance.collection('job');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data2.add(element);
      listJob.add(element['name']);
    });
    setState(() {});
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = prefs.getBool('switchValue') ?? false;
    });
  }

  void _onSwitchChanged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchValue', value);
    setState(() {
      _switchValue = value;
    });
    if (_switchValue) {
      _updateNotificationType();
    }
    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'empty': _switchValue}, SetOptions(merge: true))
        .then((value) => print("empty change"))
        .catchError((error) => print("Failed to change: $error"));

    setState(() {});
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> _getUserEmpty() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      bool emp = userSnapshot.get('empty');

      setState(() {
        _switchValue = emp;
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> _updateCityInFirestore(String city) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference userRef = firestoreInstance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      await userRef.update({'city': city});
      print('Field name updated successfully');
    } catch (e) {
      print('Error updating field name: $e');
    }
  }

  Future<void> _getUserJob() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      String job = userSnapshot.get('job');

      setState(() {
        oldJob = job;
      });
    } catch (e) {
      print('Error fetching user job: $e');
    }
  }

  Future<void> updateJobCount(String jobName, int increment) async {
    CollectionReference jobsRef = FirebaseFirestore.instance.collection('job');

    QuerySnapshot querySnapshot =
    await jobsRef.where('name', isEqualTo: jobName).get();

    if (querySnapshot.docs.isEmpty) {
      print("Job with the name '$jobName' does not exist!");
      return;
    }

    DocumentReference jobRef = querySnapshot.docs.first.reference;

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(jobRef);

      if (!snapshot.exists) {
        throw Exception("Job does not exist!");
      }

      int currentCount = snapshot['count'] ?? 0;
      int newCount = currentCount + increment;
      transaction.update(jobRef, {'count': newCount});
    }).then((value) {
      print("Job count updated");
    }).catchError((error) {
      print("Failed to update job count: $error");
    });
  }

  Future<void> _updateJobInFirestore(String job) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference userRef = firestoreInstance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      await userRef.update({'job': job});
      print('Field job updated successfully');

      if (oldJob != null) {
        await updateJobCount(oldJob!, -1); // إنقاص العدد للوظيفة القديمة
      }

      await updateJobCount(job, 1); // زيادة العدد للوظيفة الجديدة
      oldJob = job; // تحديث الوظيفة القديمة بالقيمة الجديدة
    } catch (e) {
      print('Error updating field job: $e');
    }
  }

  Future<void> deleteUser() {
    return users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> deleteCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        print('User deleted successfully');
      } else {
        print('No user signed in');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }



  Stream<int> _countUnreadNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('type', isEqualTo: 'ready')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> _updateNotificationType() async {
    try {
      CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');
      QuerySnapshot notificationSnapshot = await notifications
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var doc in notificationSnapshot.docs) {
        await notifications.doc(doc.id).update({'type': 'ready'});
      }

      print('Notification types updated successfully');
    } catch (e) {
      print('Error updating notification types: $e');
    }
  }

  Future<void> _countUnreadNotifications() async {
    try {
      CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');
      QuerySnapshot notificationSnapshot = await notifications
          .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('type', isEqualTo: 'ready')
          .where('isRead', isEqualTo: false)
          .get();

      setState(() {
        _notificationCount = notificationSnapshot.docs.length;
      });
    } catch (e) {
      print('Error counting unread notifications: $e');
    }
  }

  Color color = Colors.grey.shade50;
  bool name = false;
  bool email = false;
  bool password = false;
  bool Suggest = false;
  bool active = false;
  bool logout = false;
  int _notificationCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('الإعدادات')),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          StreamBuilder<int>(
            stream: _countUnreadNotificationsStream(),
            builder: (context, snapshot) {
              int _notificationCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                  ),
                  if (_notificationCount > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$_notificationCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StorageImageView()));
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.orange[50],
                  child: _image != null
                      ? CircleAvatar(
                    radius: 58,
                    backgroundImage: FileImage(_image!),
                  )
                      : CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.orange[50],
                    child: Icon(Icons.camera_alt,
                        size: 58, color: Colors.grey[600]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'تغيير الصورة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text(''),
                      value: _switchValue,
                      onChanged: _onSwitchChanged,
                      activeColor: Colors.deepOrange,
                      activeTrackColor: Colors.deepOrangeAccent,
                      inactiveTrackColor: Colors.grey[300],
                      contentPadding: const EdgeInsets.only(right: 80.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'حالة التفرغ',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Divider(thickness: 2),
              SizedBox(height: 20.0),
              MaterialButton(
                color: color,
                onPressed: () {
                  setState(() {
                    name = true;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => changeName()));
                  });
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تغيير الاسم',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                color: color,
                onPressed: () {
                  setState(() {
                    password = true;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Password()));
                  });
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                color: color,
                onPressed: () {
                  setState(() {
                    Suggest = true;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Suggest_page()));
                  });
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الاقتراحات',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                color: color,
                onPressed: _showCancelAccountDialog,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'حذف الحساب',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                color: color,
                onPressed: _showLogoutDialog,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // لون الخلفية الأبيض
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      "تغيير المدينة",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                    value: valueChooseCity,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String? value) {
                      setState(() {
                        valueChooseCity = value;
                      });
                      if (value != null) {
                        _updateCityInFirestore(value);
                      }
                    },
                    items: _createListCity(),
                    menuMaxHeight: 200.0, // تحديد الحد الأقصى لارتفاع القائمة
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // لون الخلفية الأبيض
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      "تغيير الوظيفة",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                    value: valueChooseJob,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String? value) {
                      setState(() {
                        valueChooseJob = value;
                      });
                      if (value != null) {
                        _updateJobInFirestore(value);
                      }
                    },
                    items: _createListJob(),
                    menuMaxHeight: 200.0, // تحديد الحد الأقصى لارتفاع القائمة
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              'تأكيد',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'هل أنت متأكد أنك تريد حذف حسابك؟',
              textAlign: TextAlign.right,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('حذف الحساب'),
                onPressed: () async {
                  DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();

                  String job = userSnapshot.get('job');
                  if (job != null) {
                    await updateJobCount(
                        job, -1); // تقليل العدد للوظيفة السابقة
                  }
                  deleteCurrentUser();
                  deleteUser();

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => firstPage()));
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.grey)),
                ),
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              'تأكيد',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'هل أنت متأكد أنك تريد تسجيل الخروج؟',
              textAlign: TextAlign.right,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('تسجيل الخروج'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => firstPage()));
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.grey)),
                ),
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}