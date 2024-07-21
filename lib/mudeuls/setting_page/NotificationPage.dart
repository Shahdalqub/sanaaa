import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/mudeuls/user/user_page2.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream;

  @override
  void initState() {
    super.initState();
    notificationsStream = FirebaseFirestore.instance
        .collection('notifications')
        .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('type', isEqualTo: 'ready')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _getUserDataStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
      print('Notification marked as read');
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(child:Text('الإشعارات')),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد إشعارات لعرضها'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index].data();
              final notificationId = notifications[index].id;
              final userId = notification['userId'];
              final date = (notification['date'] as Timestamp).toDate();

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _getUserDataStream(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('حدث خطأ في جلب بيانات المستخدم'),
                    );
                  }

                  final userData = userSnapshot.data?.data();
                  if (userData == null) {
                    return ListTile(
                      title: Text('لم يتم العثور على بيانات المستخدم'),
                    );
                  }

                  final userName = userData['name'];
                  final userImage = userData['image'];
                  final isRead = notification['isRead'] ?? false;

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserPage2(userId: userId)));
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userImage),
                        ),
                        title: Text("$userName-اصبح متفرغا الان"),
                        subtitle: Text('تاريخ الإشعار: $date'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: isRead ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            if (!isRead) {
                              _markAsRead(notificationId);
                              setState(() {
                                notification['isRead'] = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}