import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuggestionsA extends StatefulWidget {
  @override
  _SuggestionsAState createState() => _SuggestionsAState();
}

class _SuggestionsAState extends State<SuggestionsA> {
  @override
  void initState() {
    super.initState();
    getDataUsers();
  }

  List<List<Map<String, dynamic>>> usersSuggestions = [];
  List<QueryDocumentSnapshot> data = [];

  Future<void> getDataUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot userData = await users.get();

    // Iterating over each document
    for (QueryDocumentSnapshot element in userData.docs) {
      // Checking if the user has a subcollection named 'suggestions'
      QuerySnapshot suggestionsData = await element.reference.collection('suggestions').get();

      // If the subcollection 'suggestions' exists for the user
      if (suggestionsData.docs.isNotEmpty) {
        List<Map<String, dynamic>> userSuggestions = [];

        // Iterating over each suggestion document
        suggestionsData.docs.forEach((suggestionDoc) {
          Map<String, dynamic> suggestionData = suggestionDoc.data() as Map<String, dynamic>;
          userSuggestions.add(suggestionData);
        });

        // Adding the list of suggestions for the user to the main list
        usersSuggestions.add(userSuggestions);
        data.add(element);
      }
    }

    setState(() {});
  }

  void _showSquareAbove(String name, String phone, String details, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 2),
              color: Colors.white, // اللون الأبيض لكامل الـ Container
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text(name),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  title: Text(phone),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  title: Text(details),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  title: Text(time),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('الاقتراحات'),
          backgroundColor: Colors.grey[300],
        ),
        body: ListView.builder(
          itemCount:usersSuggestions.length,
          itemBuilder:(context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (Map<String, dynamic> suggestion in usersSuggestions[index])
                  Card(
                    child: ListTile(
                      onTap:(){_showSquareAbove(suggestion['name'],suggestion['phone'],suggestion['details'],suggestion['submittedAt'].toString());}
                      ,title: Text(suggestion['topic']),
                      // يمكنك إضافة المزيد من التفاصيل هنا
                    ),
                  ),
              ],
            );
          },
        )
      /*Column(
         children: <Widget>[
           SizedBox(height: 50),
           GestureDetector(
             onTap: _showSquareAbove,
             child: Container(
               width: double.infinity, // Takes full width of the screen
               height: 50,
               decoration: BoxDecoration(
                 color: Colors.orange[400],
                 borderRadius: BorderRadius.circular(10),
               ),
               alignment: Alignment.centerRight,
               child: Text(
                 'أرسل اليك أحمد اقتراح',
                 style: TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold, fontSize: 16,),
               ),
             ),
           ),
           // The rest of your page content can go here
         ],
       ),
     );*/
    );}
}