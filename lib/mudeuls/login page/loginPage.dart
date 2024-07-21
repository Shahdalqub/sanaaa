import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snaapro/mudeuls/admin_screen/admin_page.dart';
import 'package:snaapro/mudeuls/createAccunte/VerifyEmailScreen.dart';

import '../createAccunte/create_account_screen.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage> {
  bool obscureText = true;
  String? userType;
  String? email;
  String? password;
  bool colstate1 = false;
  Color c = Color.fromRGBO(255, 116, 49, 1);
  var _emailCont = TextEditingController();
  var _passCont = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey();
  List<Map<String, dynamic>> usersData = [];
  List<Map<String, dynamic>> adminData = [];

  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailCont.text.trim())
          .get();
      setState(() {
        usersData = usersSnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error fetching users data: $error');
    }
  }

  Future<void> fetchAdminData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> adminSnapshot =
      await FirebaseFirestore.instance
          .collection('admin1')
          .where('email', isEqualTo: _emailCont.text.trim())
          .get();
      setState(() {
        adminData = adminSnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error fetching admin data: $error');
    }
  }

  Future<void> loginUser() async {
    if (loginKey.currentState!.validate()) {
      loginKey.currentState!.save();
    }
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCont.text.trim(),
        password: _passCont.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerifyPage()),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}");
      String? errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'هذا الحساب غير مستخدم مسبقا';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة';
      } else {
        errorMessage = 'يبدو ان كلمة المرور غير صحيحة';
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: errorMessage ?? 'خطأ',
      )..show();
    }
  }

  Future<void> loginAdmin() async {
    if (loginKey.currentState!.validate()) {
      loginKey.currentState!.save();
    }
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCont.text.trim(),
        password: _passCont.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPge()),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}");
      String? errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'هذا الحساب غير مستخدم مسبقا';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة';
      } else {
        errorMessage = 'حدث خطأ غير متوقع';
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: errorMessage ?? 'خطأ',
      )..show();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsersData();
    fetchAdminData();
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _passCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(234, 234, 234, 1),
          appBar: AppBar(
            title: const Center(
              child: Text(
                "تسجيل الدخول",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "coconnextarabic",
                ),
              ),
            ),
            backgroundColor: Color.fromRGBO(251, 170, 58, 1),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  RadioListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.deepOrangeAccent,
                    value: "user",
                    title: const Text(
                      "مستخدم",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "coconnextarabic",
                      ),
                    ),
                    groupValue: userType,
                    onChanged: (val) {
                      setState(() {
                        userType = val;
                      });
                    },
                  ),
                  RadioListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.deepOrangeAccent,
                    value: "admin",
                    title: const Text(
                      "ادمن",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "coconnextarabic",
                      ),
                    ),
                    groupValue: userType,
                    onChanged: (val) {
                      setState(() {
                        userType = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Form(
                      key: loginKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'البريد الالكتروني:',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: c,
                                        fontFamily: "coconnextarabic",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 240.0,
                                  child: TextFormField(
                                    onSaved: (val) {
                                      email = val;
                                    },
                                    controller: _emailCont,
                                    validator: (value) {
                                      if (value!.isEmpty) return "الحقل فارغ";
                                      if (!value.contains("@"))
                                        return "يجب ان يحتوي على @";
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[300]!,
                                      filled: true,
                                      suffixIcon: Icon(Icons.email,
                                          color: Colors.grey[600]),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey[500]!,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'كلمة المرور:',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: c,
                                        fontFamily: "coconnextarabic",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    obscureText: obscureText,
                                    onSaved: (val) {
                                      password = val;
                                    },
                                    // obscureText: true,
                                    controller: _passCont,
                                    validator: (value) {
                                      if (value!.isEmpty) return "الحقل فارغ";
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[300]!,
                                      filled: true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey[500]!,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_emailCont.text == "") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'الرجاء كتابة البريد الالكتروني  ',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: _emailCont.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'لقد تم ارسال لينك لاعادة تعيين كلمة المرور',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc:
                          'الرجاء التاكد من ان البريد الالكتروني اللذي ادخلته صحيح ثم قم باعادة المحاولة',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => CreateAccount()),
                        );
                        print(e);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      alignment: Alignment.topRight,
                      child: Text(
                        'هل نسيت كلمة السر؟',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 18, color: c),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          colstate1 = true;
                        });
                        if (userType == "user") {
                          await fetchUsersData();

                          if (usersData.isNotEmpty) {
                            if (usersData.first['enabled']) {
                              loginUser();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'خطأ',
                                desc:
                                'هذا الحساب محظور يمكنك التواصل مع ادارة التطبيق 0569259815',
                              )..show();
                            }
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'خطأ',
                              desc: 'هذا الحساب غير موجود',
                            )..show();
                          }
                        } else if (userType == "admin") {
                          await fetchAdminData();
                          if (adminData.isNotEmpty) {
                            loginAdmin();
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'خطأ',
                              desc: 'هذا الحساب غير موجود',
                            )..show();
                          }
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc: 'يرجى اختيار نوع الحساب',
                          )..show();
                        }
                      },
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "CoconAE Next Arabic",
                        ),
                      ),
                      color: colstate1 ? Colors.orange : Colors.orange,
                      textColor: colstate1 ? Colors.white : Colors.white,
                      minWidth: 170,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => CreateAccount()),
                      );
                    },
                    child: Text('الذهاب لصفحة انشاء حساب '),
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      "images/Untitled-3.png",
                      height: 300,
                      width: 300,
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}