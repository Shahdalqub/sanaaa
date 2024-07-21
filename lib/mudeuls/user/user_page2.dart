import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';

import '../chat/chat.dart';

class UserPage2 extends StatefulWidget {
  final String userId;

  UserPage2({required this.userId});

  @override
  State<UserPage2> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage2> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream;
  double _rating = 0;
  bool isRated = false; // متغير لتحديد ما إذا تم التقييم بالفعل



  String chatroomid() {
    List users = [FirebaseAuth.instance.currentUser!.uid, widget.userId];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  void _addNotification() async {
    try {
      final uuid = Uuid().v4();
      final now = Timestamp.now();
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('notifications').doc(uuid).set({
        'notificationId': uuid,
        'date': now,
        'userId': widget.userId,
        'senderId': currentUserID,
        'type': 'waiting',
        'isRead': false // يمكنك تعديل هذا النوع حسب الحاجة
      });
      print('Notification added successfully');
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  Future<void> updateFieldRate(double reating, double reatingcount, double retingavarge) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference userRef = firestoreInstance.collection('users').doc(widget.userId);
      await userRef.update({'reating': reating});
      await userRef.update({'reatingcount': reatingcount});
      await userRef.update({'reatingavarge': retingavarge});
      print('Field name updated successfully');
    } catch (e) {
      print('Error updating field name: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    documentStream = FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: documentStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final userName = data['name'];
            final city = data['city'];
            final job = data['job'];
            final breif = data['brief'];
            String image1 = data['image'];
            var Reating = data['reating'];
            var reatingCount = data['reatingcount'];
            var reatingavarge = data['reatingavarge'];
            bool userempty = data['empty'];
            _rating = reatingavarge.toDouble();
            double reatingvalue = Reating.toDouble();
            double _reatingCount = reatingCount.toDouble();

            return Column(
              children: [
                Stack(
                  children: [
                    const Image(
                      image: AssetImage('images/Untitled-6.png'),
                    ),
                    Positioned(
                      top: 30.0,
                      left: 150,
                      child: Text(
                        'حساب شخصي',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 250,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(image1),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          username: userName,
                                          userimage: image1,
                                          userid: widget.userId,
                                        )));
                                  },
                                  icon: CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.deepPurpleAccent,
                                    child: Icon(
                                      Icons.message,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0), // مسافة بسيطة بين الأيقونات
                                ElevatedButton(
                                  onPressed: () {
                                    if (userempty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('هذا المستخدم متفرغ بالفعل'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.deepOrangeAccent,
                                                ),
                                                child: Text('موافق'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('هل تريد اعلامك عند تفرغ هذا الشخص؟'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('إلغاء'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _addNotification();
                                                  Navigator.of(context).pop(); // إغلاق الحوار بعد الضغط
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.deepOrangeAccent,
                                                ),
                                                child: Text('نعم'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrangeAccent,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  ),
                                  child: Text(
                                    'الحالة',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$job - $city',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 0,
                            maxRating: 5,
                            itemSize: 25,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            onRatingUpdate: (rating) {
                              setState(() {});
                            },
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                          ),
                          Text(_rating.toStringAsFixed(2))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // إخفاء زر التقييم بعد التقييم
                      isRated
                          ? SizedBox()
                          : TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              double updatedRating = _rating;
                              return AlertDialog(
                                title: Text('تقييم'),
                                content: RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  maxRating: 5,
                                  allowHalfRating: true,
                                  itemSize: 40,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                  onRatingUpdate: (rating) {
                                    if (!isRated) {
                                      updatedRating = rating;
                                      _reatingCount += 1;
                                      _rating = (reatingvalue + updatedRating) / _reatingCount;
                                      updateFieldRate(reatingvalue + updatedRating, _reatingCount, _rating);
                                    }
                                    setState(() {
                                      isRated = true; // تم التقييم بالفعل
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('إلغاء'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('تقييم'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'نبذة مختصره',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Card(
                          color: Color.fromRGBO(225, 225, 225, 1),
                          child: Container(
                            height: 250.0,
                            width: 350,
                            padding: EdgeInsets.all(30.0),
                            child: Text('${breif ?? 'نبذة مختصرة'}'),
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('post')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                              return Text('لا يوجد اعمال لعرضها');
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'عرض الاعمال',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: snapshot.data!.docs.map((postDoc) {
                                    final postData = postDoc.data();
                                    final postTitle = postData['textpost'];
                                    final postContent = postData['imagepost'];

                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(image1),
                                                  radius: 20,
                                                ),
                                                SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Text(
                                                    '$userName',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Center(
                                              child: Image.network(
                                                postContent,
                                                width: 230, //double.infinity,
                                                height: 200,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              postTitle,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
