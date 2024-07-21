import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snaapro/layout/home_layout/home_layout.dart';

class StorageImageView extends StatefulWidget {
  const StorageImageView({Key? key}) : super(key: key);

  @override
  State<StorageImageView> createState() => _StorageImageViewState();
}

class _StorageImageViewState extends State<StorageImageView> {
  String? imagePath;
  String? netUrl;

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
      isLoading = true;
      setState(() {});
      final name = imagePath!.split('/').last;
      var storage = FirebaseStorage.instance.ref("images/$name");
      await storage.putFile(File(imagePath!));
      netUrl = await storage.getDownloadURL();
      isLoading = false;
      setState(() {});
      await updateUserData();
    }
  }

  Future<void> updateUserData() async {
    if (netUrl != null) {
      try {
        // احصل على مرجع لمجموعة بيانات المستخدمين
        final userCollection = FirebaseFirestore.instance.collection('users');

        // احصل على معرف المستخدم الحالي، يمكنك استبدال 'currentUserId' بمعرف المستخدم الفعلي
        final currentUserId = 'currentUserId';

        // قم بتحديث حقل الصورة في مجموعة بيانات المستخدمين باستخدام set
        await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({'image': netUrl}, SetOptions(merge: true));

        // عرض رسالة بأن الصورة تم تحديثها بنجاح
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Storage Image',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath != null
                ? Column(
              children: [
                Image.file(
                  File(imagePath!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                !isLoading
                    ? ElevatedButton(
                  onPressed: uploadImage,
                  child: const Text('Upload image!'),
                )
                    : const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )
                : const SizedBox(),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('choose your image!'),
            ),
            const SizedBox(
              height: 50,
            ),
            (netUrl != null)
                ? Column(
              children: [
                /*Image.network(
                        netUrl!,
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 3,
                      ),*/
                const Text(
                  'image upload Succeeded',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )
                : const SizedBox(),
            Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeLayout()));
                  },
                  child: Text('الذهاب للمنزل '),
                ))
          ],
        ),
      ),
    );
  }
}
