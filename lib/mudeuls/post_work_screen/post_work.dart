import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snaapro/layout/home_layout/home_layout.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String? imagePath;
  String? netUrl;
  TextEditingController des = TextEditingController();
  // Future<void> getImage() async {
  //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (file != null) {
  //     imagePath = file.path;
  //     setState(() {});
  //   }
  // }
  //
  // bool isLoading = false;
  // Future<void> uploadImage() async {
  //   if (imagePath != null) {
  //     isLoading = true;
  //     setState(() {});
  //     final name = imagePath!.split('/').last;
  //     var storage = FirebaseStorage.instance.ref("imagespost/$name");
  //     await storage.putFile(File(imagePath!));
  //     netUrl = await storage.getDownloadURL();
  //     isLoading = false; // تعديل هنا
  //     setState(() {});
  //     await updateUserData();
  //   }
  // }
  //
  // Future<void> updateUserData() async {
  //   if (netUrl != null) {
  //     try {
  //       // احصل على مرجع لمجموعة بيانات المستخدمين
  //       final userCollection = FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .collection('post');
  //
  //       // احصل على معرف المستخدم الحالي، يمكنك استبدال 'currentUserId' بمعرف المستخدم الفعلي
  //       final currentUserId = 'currentUserId';
  //
  //       // قم بتحديث حقل الصورة في مجموعة بيانات المستخدمين باستخدام set
  //       await userCollection.add(
  //         {'imagepost': netUrl, 'textpost': des.text},
  //       );
  //
  //       // عرض رسالة بأن الصورة تم تحديثها بنجاح
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('تم تحديث الصورة بنجاح')),
  //       );
  //     } catch (error) {
  //       print('حدث خطأ أثناء تحديث البيانات: $error');
  //     }
  //   } else {
  //     print('الرابط غير متاح');
  //   }
  // }
  Future<void> getImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      imagePath = file.path;
      setState(() {});
    }
  }

  bool isLoading = false;

  Future<void> uploadImage() async {
    if (imagePath != null) {
      setState(() {
        isLoading = true;
      });

      final name = imagePath!.split('/').last;
      var storage = FirebaseStorage.instance.ref("imagespost/$name");

      try {
        await storage.putFile(File(imagePath!));
        netUrl = await storage.getDownloadURL();

        setState(() {
          isLoading = false;
        });

        await updateUserData();
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

  Future<void> updateUserData() async {
    if (netUrl != null) {
      try {
        final userCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('post');

        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        await userCollection.add({
          'imagepost': netUrl,
          'textpost': des.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث الصورة بنجاح')),
        );
      } catch (error) {
        print('حدث خطأ أثناء تحديث البيانات: $error');
      }
    } else {
      print('الرابط غير متاح');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeLayout()));
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 26,
                      )),
                  Text(
                    'اضافة عمل',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        uploadImage();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeLayout()));
                      },
                      child: Text('اضافة',
                          style: TextStyle(
                            fontSize: 24,
                          )))
                ],
              ),
              imagePath == null
                  ? SizedBox(
                height: h * 0.4,
              )
                  : Image.file(
                File(imagePath!),
                height: h * 0.4,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              IconButton(
                  onPressed: () {
                    getImage();
                  },
                  icon: Icon(
                    Icons.upload,
                    size: 28,
                  )),
              TextField(
                controller: des,
                maxLines: 15,
                decoration: InputDecoration(
                    hintText: 'اكتب شرح',
                    hintTextDirection: TextDirection.rtl,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              )
            ],
          ),
        ),
      ),
    );
  }
}