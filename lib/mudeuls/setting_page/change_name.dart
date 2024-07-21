import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/layout/home_layout/home_layout.dart';


class changeName extends StatefulWidget {
  @override
  _changeName createState() => _changeName();
}

class _changeName extends  State<changeName> {
  final TextEditingController oldname = TextEditingController();
  final TextEditingController newname = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future<void> updateFieldName(String userId, String newFieldValue) async {
    try {
      // Access Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;

      // Reference to the document with the specified userId
      DocumentReference userRef = firestoreInstance.collection('users').doc(userId);

      // Update the specific field
      await userRef.update({'name': newFieldValue});

      print('Field name updated successfully');
    } catch (e) {
      print('Error updating field name: $e');
    }
  }
  @override
  void initState() {
    // getDataName();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تغيير الاسم',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        automaticallyImplyLeading: false, // Prevent default back button
        actions: [ // Place back button in the actions to align it on the right in RTL
          IconButton(
            icon: Icon(Icons.arrow_forward), // Change to arrow_forward for RTL appropriate navigation
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Text('الاسم الجديد',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    textAlign: TextAlign.right),
              ),
              SizedBox(height: 8),
              _buildCustomTextFormField(context, oldname, 'ادخل الاسم الجديد'),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(' كرر الاسم الجديد',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    textAlign: TextAlign.right),
              ),
              SizedBox(height: 8),
              _buildCustomTextFormField(context, newname, 'كرر الاسم الجديد'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if(oldname.text.trim()==newname.text.trim()){
                        updateFieldName(FirebaseAuth.instance.currentUser!.uid.toString(),newname.text.trim());
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'نجاح',
                          desc: "لقد نجحت العملية",
                          btnOkText: 'موافق',
                          btnOkOnPress: () {
                            // تحديث الشاشة هنا
                            setState(() {
                              // يمكنك هنا تحديث البيانات إذا لزم الأمر
                            });
                            Navigator.of(context).pop(); // إغلاق الحوار بعد النقر على زر "موافق"
                          },
                        )..show();

                      }
                      else{
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "تحذير",
                          desc: "الاسم غير متطابق",
                          btnOkText: 'موافق',
                          btnOkOnPress: () {

                            Navigator.of(context).pop(); // إغلاق الحوار بعد النقر على زر "موافق"
                          },
                        )..show();
                      }

                    }
                  },
                  child: Text(
                    'تحديث',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextFormField(BuildContext context, TextEditingController controller, String label) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Text field cleared'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[500]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[500]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.orange, width: 1.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}