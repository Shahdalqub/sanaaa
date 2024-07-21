import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  void _deleteJob(String docId) {
    FirebaseFirestore.instance.collection('job').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المهن'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('job').orderBy("created_at",descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String docId = snapshot.data!.docs[index].id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // زوايا منجنية
                  ),
                  child: ListTile(
                    title: Text(
                      data['name'],
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                      //  _deleteJob(docId);
                        showDialog(
                          context: context,
                          builder: (BuildContext
                          context) {
                            return AlertDialog(
                              title: Text(
                                  "حذف المهنة"),
                              content: Text(
                                  "هل أنت متأكد أنك تريد حذف المهنة؟"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                        context)
                                        .pop();
                                  },
                                  child:
                                  Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed:
                                      ()  {
                                    // Execute delete logic here
                                    Navigator.of(
                                        context)
                                        .pop();
                                    _deleteJob(docId);// Uncomment and replace with your delete logic
                                    Navigator.of(
                                        context)
                                        .pop();
                                  },
                                  child:
                                  Text("حذف"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}