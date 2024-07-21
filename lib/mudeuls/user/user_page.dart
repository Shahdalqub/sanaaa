import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/mudeuls/chat/chat_screen.dart';

import '../firstPage/firstPage.dart';
import '../post_work_screen/post_work.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double size = 30;
  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream =
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
  TextEditingController breif1 = TextEditingController();

  List<QueryDocumentSnapshot> data1 = [];
  Future<void> getUserData() async {
    try {
      final userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('post');
      final querySnapshot = await userCollection.get();
      data1.addAll(querySnapshot.docs);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> addBriefToUserCollection(String brief) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      await userRef.set(
        {'breif': brief},
        SetOptions(merge: true),
      );

      print('Brief added successfully');
    } catch (e) {
      print('Error adding brief: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      // Get a reference to the document within the subcollection
      final postRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('post')
          .doc(postId);

      // Delete the document
      await postRef.delete();

      print('Post deleted successfully');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success, // Consider using error type (ERROR)
        animType: AnimType.rightSlide,
        title: 'حذف المنشور',
        desc: 'تم حذف المنشور بنجاح',
      )..show();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> signOutAndNavigateToFirstPage(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>firstPage()),
    );
  }
  @override
  void initState() {
    super.initState();
    getUserData();
    if(!enabled){
      signOutAndNavigateToFirstPage(context);
    }

  }
  bool enabled=true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
        final breif = data['breif'];
        String image1 = data['image'];
         enabled=data['enabled'];

        if (!enabled) {
          signOutAndNavigateToFirstPage(context);
          return Container(); // This prevents further UI rendering
        }
        return Scaffold(
          backgroundColor: Color.fromRGBO(234, 234, 234, 1),
          body: SingleChildScrollView(
            child: Column(
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
                                    setState(() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatsScreen(),
                                        ),
                                      );
                                    });
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
                                )
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
                                  '$job -$city',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'نبذة مختصره',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Card(
                          color: Color.fromRGBO(225, 225, 225, 1),
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Container(
                              height: 150.0,
                              width: 250,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('تعديل'),
                                              content: TextFormField(
                                                controller: breif1,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'نبذة مختصرة',
                                                ),
                                                maxLines: null,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    addBriefToUserCollection(
                                                        breif1.text.trim());
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('حسنا'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.orange,
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                  // Text(document['brief'] ?? 'اكتب نبذة'),
                                  Text('${breif??'نبذة مختصرة'}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PostScreen(),
                                    ),
                                  );
                                },
                                icon: CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.deepPurpleAccent,
                                  child: Icon(
                                    Icons.add,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'الاعمال',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('post')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.data == null ||
                                snapshot.data!.docs.isEmpty) {
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(image1),
                                                  radius: 20,
                                                ),
                                                SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Text(
                                                    '$userName',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "حذف المنشور"),
                                                          content: Text(
                                                              "هل أنت متأكد أنك تريد حذف هذا المنشور؟"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("إلغاء"),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // Execute delete logic here
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await deletePost(
                                                                    postDoc
                                                                        .id); // Uncomment and replace with your delete logic
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("حذف"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
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
            ),
          ),
        );
      },
    );
  }
}
