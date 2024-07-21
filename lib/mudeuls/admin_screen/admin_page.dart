import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snaapro/mudeuls/admin_screen/SuggestionsA.dart';
import 'package:snaapro/mudeuls/admin_screen/usersPage.dart';
import 'dart:io';
import '../firstPage/firstPage.dart';
import 'blockusersPage.dart';
import 'citiesPage.dart';
import 'jopPage.dart';

class AdminPge extends StatefulWidget {
  @override
  State<AdminPge> createState() => _AdminPgeState();
}

class _AdminPgeState extends State<AdminPge> {
  double size = 30;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var addCity = TextEditingController();
  var aadJob = TextEditingController();
  String? selectedOption;

  Future<void> addCityToCollection(String cityName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> existingCities = await FirebaseFirestore.instance
          .collection('city')
          .where('name', isEqualTo: cityName)
          .get();

      if (existingCities.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('city').add({
          'name': cityName,
          'created_at': FieldValue.serverTimestamp(),
        });
        print('City added successfully!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('إضافة مدينة'),
              content: Text('تم إضافة المدينة بنجاح'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('حسنًا'),
                ),
              ],
            );
          },
        );
      } else {
        print('City already exists!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('إضافة مدينة'),
              content: Text('هذه المدينة موجودة بالفعل'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('حسنًا'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error adding city: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('خطأ'),
            content: Text('حدث خطأ أثناء إضافة المدينة: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('حسنًا'),
              ),
            ],
          );
        },
      );
    }
  }


  String? imagePath;
  String? netUrl;
  bool isLoading = false;
  Future<void> getImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      imagePath = file.path;
      setState(() {
        uploadImage();
      });
    }
  }
  Future<void> uploadImage() async {
    if (imagePath != null) {
      setState(() {
        isLoading = true;
      });

      final name = imagePath!.split('/').last;
      var storage = FirebaseStorage.instance.ref("imagejop/$name");

      try {
        await storage.putFile(File(imagePath!));
        netUrl = await storage.getDownloadURL();

        setState(() {
          isLoading = false;
        });

        // await updateUserData();
      } catch (error) {
        print('حدث خطأ أثناء تحميل الصورة: $error');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('لا يوجد مسار للصورة');
    }
  }

  Future<void> addJobToCollection(String jobName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("قم بإرفاق صورة للمهنة"),
              IconButton(
                onPressed: () {
                  getImage();
                },
                icon: Icon(
                  Icons.upload,
                  size: 28,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (imagePath != null) {
                  await uploadImage();
                  if (netUrl != null) {
                    try {
                      QuerySnapshot<Map<String, dynamic>> existingJobs =
                      await FirebaseFirestore.instance
                          .collection('job')
                          .where('name', isEqualTo: jobName)
                          .get();

                      if (existingJobs.docs.isEmpty) {
                        await FirebaseFirestore.instance
                            .collection('job')
                            .add({
                          'name': jobName,
                          'image': netUrl,
                          'created_at': FieldValue.serverTimestamp(),
                          'count': 0
                        });
                        print('Job added successfully!');
                        Navigator.pop(context); // Close the dialog before showing success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('إضافة مهنة'),
                              content: Text('تم إضافة المهنة بنجاح'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('حسنا'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print('Job already exists!');
                        Navigator.pop(context); // Close the dialog before showing warning dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('إضافة مهنة'),
                              content: Text('هذه المهنة موجودة بالفعل'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('حسنا'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      print('Error adding job: $e');
                      Navigator.pop(context); // Close the dialog before showing error dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('خطأ'),
                            content: Text('حدث خطأ أثناء إضافة المهنة: $e'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('حسنا'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    Navigator.pop(context); // Close the dialog before showing error dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('خطأ'),
                          content: Text('لم يتم تحميل الصورة بشكل صحيح'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('حسنا'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  Navigator.pop(context); // Close the dialog before showing warning dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('تحذير'),
                        content: Text('يرجى إرفاق صورة للمهنة'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('حسنا'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('حسنا'),
            ),
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
  }




  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream =
  FirebaseFirestore.instance
      .collection('admin1')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
          color: Colors.grey[500]!,
          width: 2.0),
    );

    return StreamBuilder<DocumentSnapshot>(
      stream: documentStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final adminName = data['name'];

        return Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                        ),
                        child: Center(child:Text(
                          'البيانات ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),)
                    ),
                    ListTile(
                      title: Text('الاقتراحات'),
                      leading: Icon(Icons.feedback),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SuggestionsA(),
                        ));
                      },
                    ),
                    ListTile(
                      title: Text('عرض قائمة المدن'),
                      leading: Icon(Icons.location_city),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CitiesPage()));
                      },
                    ),
                    ListTile(
                      title: Text('عرض قائمة المهن'),
                      leading: Icon(Icons.work),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => JobsPage()));
                      },
                    ),
                    ListTile(
                      title: Text('عرض قائمة المستخدمين والحظر'),
                      leading: Icon(Icons.block_flipped),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => usersPage()));
                      },
                    ),
                    ListTile(
                      title: Text('ازالة الحظر عن المستخدمين'),
                      leading: Icon(Icons.group_remove_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => blockusersPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app_rounded),
                      title: Text('تسجيل الخروج'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
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
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text('تسجيل الخروج'),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => firstPage()));
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[800],
                                    backgroundColor: Colors.white,
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
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )),
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
                        'المسؤول',
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
                          backgroundImage: AssetImage(
                            'images/Untitled-24.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: Icon(Icons.menu, size: 30),
                                      onPressed: () {
                                        scaffoldKey.currentState!.openDrawer();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 180),
                                  Text(
                                    adminName,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Text(
                                'مبرمج',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                            buildTextFormField(addCity, 'اضافة مدينة',
                                borderStyle, Icons.add, () {
                                  addCityToCollection(addCity.text.trim());
                                  print("Add city tapped");
                                }),
                            SizedBox(height: 25),
                            buildTextFormField(aadJob, 'اضافة مهنة',
                                borderStyle, Icons.add, () {
                                  addJobToCollection(aadJob.text.trim());
                                  print("Add job tapped");
                                }),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label,
      OutlineInputBorder border, IconData icon, void Function() onTap) {
    return Container(
      width: 200,
      height: 60,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: label,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            filled: true,
            fillColor: Colors.grey[300]!,
            suffixIcon: IconButton(
              icon: Icon(icon),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }
}