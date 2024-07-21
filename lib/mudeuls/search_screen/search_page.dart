import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../chat/chat.dart';
import '../user/user_page2.dart';

class searchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
      locale: Locale('ar', 'AE'), // Arabic, United Arab Emirates
      supportedLocales: [Locale('ar', 'AE')],
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedOption1;
  String? selectedOption2;
  String? selectedRadio;
  bool showImage = true; // State to control the visibility of the image

  List<String> options1 = [];

  List<String> options2 = [];

  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> data = [];

  Future getDataCity() async {
    options2 = [];
    CollectionReference users = FirebaseFirestore.instance.collection('city');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data.add(element);
      options2.add(element['name']);
    });
    setState(() {});
  }

  Future getDataJob() async {
    options1 = [];
    CollectionReference users = FirebaseFirestore.instance.collection('job');
    QuerySnapshot userData = await users.get();
    userData.docs.forEach((element) {
      data.add(element);
      options1.add(element['name']);
    });
    setState(() {});
  }

  @override
  void initState() {

    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        if (!showImage) {
          setState(() {
            showImage = true;
            searchResults=[];
          });
        }
      } else {
        if (showImage) {
          setState(() {
            showImage = false;
          });
        }
      }
    });
    getDataCity();
    getDataJob();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('البحث', style: TextStyle(color: Colors.grey[800])),
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              radioButtonsRow(),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cityDropdown(), // Dropdown for city selection
                    SizedBox(width: 10),
                    jobDropdown(), // Dropdown for job selection
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        performSearch();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              customSearchBar(), // Custom search bar without dropdown
              SizedBox(height: 20),
              if (showImage) SizedBox(height: 100),
              if (showImage)
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    'images/Untitled-27.png',
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 10),
              if (searchResults.isEmpty)
                Center(child: Text('No results found'))
              else
                ListView.builder(
                  shrinkWrap: true, // يضبط ارتفاع ListView تلقائيًا بناءً على عناصره
                  physics: NeverScrollableScrollPhysics(), // يمنع التمرير داخل ListView
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot document = searchResults[index];

                    // Access and display data from each search result
                    return GestureDetector(
                      onTap: () {
                        if (document['enabled'] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage2(userId: document.id),
                            ),
                          );
                        }
                        else {
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
                            backgroundImage: NetworkImage(document['image']),
                            radius: 30,
                          ),
                          title: Text(document['name']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${document['city']}-${document['empty'] ? 'متفرغ' : 'غير متفرغ'}" ?? 'N/A',
                              ),
                              Text('${document['job']}')
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                          if (document['enabled'] == true) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  username: document['name'],
                                  userimage: document['image'],
                                  userid: document.id,
                                ),
                              ));}
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('حساب محظور'),
                                  content: Text('هذا الحساب محظور ولا يمكن مراسلته'),
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
                            icon: Icon(Icons.mark_chat_read_rounded),
                          ),
                        ),
                      ),
                    );
                  },
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget customSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'اكتب هنا للبحث',
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
        ),
        onSubmitted: (value) {
          performNameSearch();
        },
      ),
    );
  }

  Widget cityDropdown() {
    return Container(
      width: 150, // Reduced width
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedOption2,
        hint: Text('المدينة',
            style: TextStyle(color: Colors.grey[800], fontSize: 16)),
        onChanged: (String? newValue) {
          setState(() => selectedOption2 = newValue);
        },
        items: options2.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: double
                  .infinity, // Forces each item to fill the dropdown width
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: 8), // Optional padding for text
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(value,
                      style: TextStyle(color: Colors.grey[800], fontSize: 16))),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget jobDropdown() {
    return Container(
      width: 170, // Reduced width
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedOption1,
        hint: Text('المهنة',
            style: TextStyle(color: Colors.grey[800], fontSize: 16)),
        onChanged: (String? newValue) {
          setState(() => selectedOption1 = newValue);
        },
        items: options1.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: double
                  .infinity, // Forces each item to fill the dropdown width
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: 8), // Optional padding for text
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(value,
                      style: TextStyle(color: Colors.grey[800], fontSize: 16))),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget radioButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        containerRadioListTile('عامل', 'عامل'),
        containerRadioListTile('صاحب عمل', "صاحب عمل"),
      ],
    );
  }

  Widget containerRadioListTile(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.41,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(5),
      child: RadioListTile(
        title: Text(title,
            style: TextStyle(fontSize: 14, color: Colors.grey[800])),
        value: value,
        groupValue: selectedRadio,
        onChanged: (value) {
          setState(() {
            selectedRadio = value;
          });
        },
        dense: true,
        activeColor: Colors.orange[300], // Set the active color to orange
      ),
    );
  }

  List<DocumentSnapshot> searchResults = []; // List to store search results

  Future<void> performSearch() async {//city and job
    setState(() {
      showImage = false;
    });
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await usersCollection
        .where('job', isEqualTo: selectedOption1)
        .where('city', isEqualTo: selectedOption2)
        .where('userType', isEqualTo: selectedRadio)
        .get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
  }


  Future<void> performNameSearch() async {
    setState(() {
      searchResults = [];
    });
     if(searchController.text.trim().isNotEmpty){
    final usersCollection = FirebaseFirestore.instance.collection('users');
    String searchText = searchController.text.trim().toLowerCase();

    final querySnapshot = await usersCollection
        .orderBy('name')
        .startAt([searchText])
        .endAt([searchText + '\uf8ff'])
        .get();

    setState(() {
      searchResults = querySnapshot.docs;
    });}
  }
}