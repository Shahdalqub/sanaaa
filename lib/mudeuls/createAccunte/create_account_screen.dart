import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../login page/loginPage.dart';
import 'VerifyEmailScreen.dart';

class CreateAccount extends StatefulWidget {
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  Color c = Color.fromRGBO(240, 240, 240, 1);
  Color co = Color.fromRGBO(255, 116, 49, 1);
  bool colstatei = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String email = "", password = "";
  bool isPasswordValid = true;
  bool isEmailValid = true;
  var _emailCont = TextEditingController();

  var _passCont = TextEditingController();

  var _nameCont = TextEditingController();

  var _dateController = TextEditingController();

  @override
  void dispose() {
    _nameCont.dispose();
    _emailCont.dispose();
    _passCont.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _citiesList = [];

  @override
  void initState() {
    super.initState();
    getDataCity();
    getDataJob();
  }

  List<QueryDocumentSnapshot> data = [];
  Future<void> getDataCity() async {
    listCity = [];
    CollectionReference users = FirebaseFirestore.instance.collection('city');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data.add(element);
      listCity.add(element['name']);
    });
    setState(() {});
  }

  List<QueryDocumentSnapshot> data2 = [];
  Future<void> getDataJob() async {
    listJob = [];
    CollectionReference users = FirebaseFirestore.instance.collection('job');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data2.add(element);
      listJob.add(element['name']);
    });
    setState(() {});
  }

  Future<void> updateJobCount(String jobName) async {
    CollectionReference jobsRef = FirebaseFirestore.instance.collection('job');

    // البحث عن المستند باستخدام الحقل "name"
    QuerySnapshot querySnapshot =
    await jobsRef.where('name', isEqualTo: jobName).get();

    if (querySnapshot.docs.isEmpty) {
      print("Job with the name '$jobName' does not exist!");
      return;
    }

    // الحصول على المستند الأول من نتائج الاستعلام
    DocumentReference jobRef = querySnapshot.docs.first.reference;

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(jobRef);

      if (!snapshot.exists) {
        throw Exception("Job does not exist!");
      }

      int currentCount =
          snapshot['count'] ?? 0; // التأكد من وجود القيمة الحالية
      int newCount = currentCount + 1;
      transaction.update(jobRef, {'count': newCount});
    }).then((value) {
      print("Job count updated");
    }).catchError((error) {
      print("Failed to update job count: $error");
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> create() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // التحقق من البريد الإلكتروني في مجموعة block
     /* bool isBlocked = await checkIfEmailBlocked(_emailCont.text.trim());
      if (isBlocked) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Blocked Email',
          desc:
          'البريد الإلكتروني محظور. لا يمكنك إنشاء حساب بهذا البريد الإلكتروني.',
        )..show();
        return;
      }*/

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCont.text,
          password: _passCont.text,
        );

        addUser(
            FirebaseAuth.instance.currentUser!.uid,
            _nameCont.text.trim(),
            _emailCont.text.trim(),
            _passCont.text.trim(),
            valueChooseCity,
            gender.trim(),
            _dateController.text.trim(),
            valueChooseJob,
            worlker);
        await updateJobCount(valueChooseJob!);
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const VerifyPage()));
      } on FirebaseAuthException catch (e) {
        String info = "";
        if (e.code == 'weak-password') {
          info = 'كلمة السر ضعيفة ';
        } else if (e.code == 'email-already-in-use') {
          info = 'هذا الحساب مستخدم';
        } else {
          info = 'حدث خطأ ما';
        }

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'خطأ',
          desc: info,
        )..show();
      }
    }
  }

 /* Future<bool> checkIfEmailBlocked(String email) async {
    CollectionReference blockCollection =
    FirebaseFirestore.instance.collection('block');
    QuerySnapshot querySnapshot =
    await blockCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }*/

  Future<void> addUser(
      String id,
      String name,
      String email,
      String password,
      String? city,
      String gender,
      String barthdate,
      String? job,
      String? userType) async {
    return users
        .doc(id)
        .set(
      {
        'id': id,
        'name': name,
        'email': email,
        'city': city,
        'gender': gender,
        'barthdate': barthdate,
        'job': job,
        'userType': userType,
        'empty': false,
        'image':
        'https://firebasestorage.googleapis.com/v0/b/sanaa-704e9.appspot.com/o/images%2FUntitled-28.png?alt=media&token=a4570ad3-784d-41b3-89e5-8998b6a8a454',
        'reating': 0,
        'reatingcount': 0,
        'reatingavarge': 0,
        'breif': "",
        'enabled': true
      },
      SetOptions(merge: true),
    )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String gender = '';
  String worlker = 'زبون';
  String? valueChooseCity;
  var listCity = [
    "المدينة",
    "طولكرم",
    "الخليل",
    "بيت لحم",
    "جنين",
    "قلقيلية",
    "طوباس",
    "رام الله",
    "نابلس",
    "القدس"
  ];
  var formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _createListCity() {
    return listCity
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ),
    )
        .toList();
  }

  bool obscureText = true;
  String? valueChooseJob;
  var listJob = ['نجار', "حداد", "بناء", "صيانة سيارات", "طباخ"];
  List<DropdownMenuItem<String>> _createListJob() {
    return listJob
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 170, 58, 1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        title: Text(
          'انشاء حساب',
        ),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage('images/Untitled-4.png'),
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        width: 230.0,
                        child: TextFormField(
                          controller: _nameCont,
                          onFieldSubmitted: (val) {
                            print(val);
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(225, 225, 225, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.people,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'الاسم',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        width: 230.0,
                        child: TextFormField(
                          controller: _emailCont,
                          onFieldSubmitted: (val) {
                            print(val);
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(225, 225, 225, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email.';
                            } else if (!value.contains('@gmail')) {
                              return 'يجب ان يحتوي على @';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'البريد الالكتروني',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        width: 230.0,
                        child: TextFormField(
                          controller: _passCont,
                          onFieldSubmitted: (val) {
                            print(val);
                          },
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(225, 225, 225, 1),
                            filled: true,
                            // prefixIcon: Icon(
                            //   Icons.lock,
                            // ),
                            prefixIcon: IconButton(
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
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password.';
                            } else if (value.length < 6) {
                              return 'يجب ان لا تقل عن 6 احرف';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'كلمة المرور',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        width: 230.0,
                        child: TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(225, 225, 225, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.calendar_today,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your birth date.';
                            }
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _dateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'تاريخ الميلاد',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 230.0,
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          items: _createListCity(),
                          value: valueChooseCity,
                          onChanged: (newValue) {
                            setState(() {
                              valueChooseCity = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'المدينة',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 230.0,
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          items: _createListJob(),
                          value: valueChooseJob,
                          onChanged: (newValue) {
                            setState(() {
                              valueChooseJob = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'الوظيفة',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    activeColor: co,
                                    value: 'ذكر',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'ذكر',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    activeColor: co,
                                    value: 'أنثى',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'أنثى',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'الجنس',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  activeColor: co,
                                  value: 'عامل',
                                  groupValue: worlker,
                                  onChanged: (value) {
                                    setState(() {
                                      worlker = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'عامل',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  activeColor: co,
                                  value: 'صاحب عمل',
                                  groupValue: worlker,
                                  onChanged: (value) {
                                    setState(() {
                                      worlker = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'صاحب عمل',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'نوع المستخدم',
                            style: TextStyle(
                              color: co,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: create,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(co),
                      ),
                      child: Text(
                        'إنشاء الحساب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => loginPage()));
                        },
                        child: Text('الذهاب لصفحة تسجيل الدخول '),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}