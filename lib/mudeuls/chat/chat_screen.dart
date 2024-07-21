

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
        backgroundColor:
            Color.fromRGBO(255, 115, 0, 1), // تغيير لون الشريط العلوي
        title: Center(child:Text(
          'الرسائل',
          style:
              TextStyle(color: Colors.white), // تغيير لون النص في الشريط العلوي
        ),)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsetsDirectional.only(
                      start: 16.0,
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(
                          color: Colors.black), // تغيير لون النص في حقل البحث
                      decoration: InputDecoration(
                        hintText: 'بحث',
                        hintStyle: TextStyle(
                            color: Colors
                                .grey), // تغيير لون النص التلميح في حقل البحث
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey, // تغيير لون أيقونة البحث
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        6.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .where('participants',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) {
                    print("حدثت مشكلة: ${snapshot.error}");
                    return Text("حدثت مشكلة أثناء جلب البيانات");
                  }

                  var chatDocs = snapshot.data!.docs;
                  if (_searchText.isNotEmpty) {
                    chatDocs = chatDocs.where((doc) {
                      Map<String, dynamic> chatmap =
                          doc.data() as Map<String, dynamic>;
                      String currentid = FirebaseAuth.instance.currentUser!.uid;
                      String name = currentid == chatmap['senderid']
                          ? chatmap['recivername']
                          : chatmap['sendername'];
                      return name.contains(_searchText);
                    }).toList();
                  }

                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> chatmap =
                          chatDocs[index].data() as Map<String, dynamic>;
                      String currentid = FirebaseAuth.instance.currentUser!.uid;
                      String name = currentid == chatmap['senderid']
                          ? chatmap['recivername']
                          : chatmap['sendername'];
                      String image = currentid == chatmap['senderid']
                          ? chatmap['reciverimage']
                          : chatmap['senderimage'];
                      String uid = currentid == chatmap['senderid']
                          ? chatmap['reciverid']
                          : chatmap['senderid'];
                      String lastMessage = chatmap['lastMessage'] ?? '';
                      Timestamp date = chatmap['date'];

                      // تنسيق التاريخ
                      String formattedDate =
                          DateFormat('hh:mm a').format(date.toDate());

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                username: name,
                                userimage: image,
                                userid: uid,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // Aligns content to the right
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        formattedDate, // عرض التاريخ المنسق
                                        style: TextStyle(
                                            color:
                                                Colors.grey), // تغيير لون النص
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          bottom: 5.0,
                                        ),
                                        child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50.0,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                image,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   width: 15.0,
                                      //   height: 15.0,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.green,
                                      //     shape: BoxShape.circle,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                6.0,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16.0,
                    ),
                    itemCount: chatDocs.length,
                  );
                }),
          ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}
