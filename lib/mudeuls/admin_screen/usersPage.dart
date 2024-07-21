import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class usersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<usersPage> {
  late List<Map<String, dynamic>> usersData = [];

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('users').where('enabled',isEqualTo: true).get();
      setState(() {
        usersData = usersSnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error fetching users data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حظر المستخدمين'),
      ),
      body: ListView.builder(
        itemCount: usersData.length,
        itemBuilder: (context, index) {
          final userName = usersData[index]['name'];
          final userEmail = usersData[index]['email'];
          final userId = usersData[index]['id']; // تخمين الـ ID

          return Card(
            color: Colors.deepOrange.withOpacity(0.8),
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                userName != null ? userName : 'No name',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                userEmail != null ? userEmail : 'No email',
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(Icons.person_off_sharp, color: Colors.white),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'تأكيد',
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'هل أنت متأكد أنك تريد حظر الحساب؟',
                          textAlign: TextAlign.right,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: Text('حظر الحساب'),
                            onPressed: () async {
                              // قم بحذف الحساب باستخدام ID
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .update({'enabled':false});
                                // بعد الحذف، يمكنك إعادة تحميل البيانات لتحديث الواجهة
                                fetchUsersData();
                              } catch (error) {
                                print('Error deleting user account: $error');
                              }
                              Navigator.of(context)
                                  .pop(); // إغلاق الحوار بعد الحذف
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[800],
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text('إلغاء'),
                            onPressed: () {
                              // إغلاق الحوار بدون حذف
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
