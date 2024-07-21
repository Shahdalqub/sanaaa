import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool isPasswordValid = true;
  bool isPasswordValid2 = true;
  var oldpassword = TextEditingController();
  var newpassword = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Future<void> updatePassword(String newPassword) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is signed in
      if (user != null) {
        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldpassword.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'نجاح',
          desc: "لقد نجحت العملية",
          btnOkText: 'موافق',
          btnOkOnPress: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        ).show();
      } else {
        print('User is not signed in');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'خارج الخدمة',
          desc: "غير مسجل",
          btnOkText: 'موافق',
          btnOkOnPress: () {
            setState(() {});
            Navigator.of(context).pop();
          },
        ).show();
      }
    } catch (error) {
      print('Error updating password: ${error.toString()}');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: "لقد حدث خطأ: ${error.toString()}",
        btnOkText: 'موافق',
        btnOkOnPress: () {
          setState(() {});
          Navigator.of(context).pop();
        },
      ).show();
    }
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
          'تغيير كلمة المرور',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
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
                child: Text(
                  'كلمة السر القديمة',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              _buildCustomTextFormField(context, oldpassword, 'ادخل كلمة السر القديمة'),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  ' كلمة السر الجديدة',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 8),
              _buildCustomTextFormField(context, newpassword, ' كلمة السر الجديدة'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                     /* if (newpassword.text.trim() != oldpassword.text.trim()) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: "خطأ",
                          desc: "كلمة المرور غير متطابقة",
                          btnOkText: 'موافق',
                          btnOkOnPress: () {
                            Navigator.of(context).pop();
                          },
                        ).show();
                      } else {*/
                        await updatePassword(newpassword.text.trim());
                     // }
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
