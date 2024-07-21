import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/mudeuls/chat/chat.dart';

import '../user/user_page2.dart';

class UserJob extends StatefulWidget {
  final String job;

  const UserJob({super.key, required this.job});

  @override
  State<UserJob> createState() => _UserJobState();
}

class _UserJobState extends State<UserJob> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where('job', isEqualTo: widget.job)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text('No users found with job: ${widget.job}'));
            }

            final users = snapshot.data!.docs;

            return ListView.separated(
              padding: EdgeInsets.only(top: 16.0), // إضافة الفراغ في أعلى الصفحة
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    if (user['enabled'] == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage2(userId: user.id),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('حساب محظور'),
                            content: Text('هذا الحساب محظور ولا يمكن الانتقال إلى صفحته.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('حسنا'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['image']),
                        radius: 30,
                      ),
                      title: Text(user['name']),
                      subtitle: Text(
                        "${user['city']}-${user['empty'] ? 'متفرغ' : 'غير متفرغ'}" ?? 'N/A',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              username: user['name'],
                              userimage: user['image'],
                              userid: user.id,
                            ),
                          ));
                        },
                        icon: Icon(Icons.mark_chat_read_rounded),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 16.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
