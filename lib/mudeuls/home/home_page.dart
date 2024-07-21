import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:snaapro/mudeuls/home/userJob.dart';

import '../user/user_page2.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double sizeFont = 30.0;
  final double hight = 5.0;

  Stream<List<Map<String, String>>> fetchAlljobStream() {
    return FirebaseFirestore.instance
        .collection('job')
        .snapshots()
        .map((snapshot) {
      List<Map<String, String>> job = [];
      snapshot.docs.forEach((doc) {
        String jobName = doc['name'];
        String jobImage = doc['image'];

        Map<String, String> jobData = {
          'name': jobName,
          'image': jobImage,
        };

        job.add(jobData);
      });
      return job;
    });
  }

  Stream<List<Map<String, dynamic>>> fetchJobDataStream1() {
    return FirebaseFirestore.instance
        .collection('job')
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> jobsList = [];

      snapshot.docs.forEach((doc) {
        String? jobName = doc['name'];
        String? jobImage = doc['image'];
        // Assuming 'count' is a field in your Firestore document

        if (jobName != null) {
          Map<String, dynamic> jobData = {
            'name': jobName,
            // Provide a default value if jobImage is null
          };

          jobsList.add(jobData);
        }
      });
      // Sort jobsList by count in descending order
      jobsList.sort((a, b) => b['count'].compareTo(a['count']));

      return jobsList;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image(
                image: AssetImage('images/Untitled-7.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'الأكثر طلبا',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('job')
                  .orderBy('count', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                int highestRatingValue = docs.isNotEmpty ? docs[0]['count'] : 0;
                List<QueryDocumentSnapshot> highestRatedDocs = docs
                    .where((doc) => doc['count'] == highestRatingValue)
                    .toList();

                List<QueryDocumentSnapshot> usersToShow;
                if (highestRatedDocs.length > 4) {
                  usersToShow = highestRatedDocs;
                } else {
                  usersToShow = docs.take(4).toList();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: usersToShow
                        .map((doc) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UserJob(job: doc['name'])));
                        },
                        child: defaultJob(
                          img: doc['image'],
                          jobName: doc['name'],
                        ),
                      );
                    })
                        .take(4)
                        .toList(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'الأعلى تقييما',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('reatingavarge', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                double highestRatingValue =
                docs.isNotEmpty ? docs[0]['reatingavarge'] : 0;
                List<QueryDocumentSnapshot> highestRatedDocs = docs
                    .where((doc) => doc['reatingavarge'] == highestRatingValue)
                    .toList();

                List<QueryDocumentSnapshot> usersToShow;
                if (highestRatedDocs.length > 3) {
                  usersToShow = highestRatedDocs;
                } else {
                  usersToShow = docs.take(3).toList();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: usersToShow.map((doc) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage2(userId: doc.id),
                            ),
                          );
                        },
                        child: highestRating(
                          img: doc['image'],
                          name: doc['name'],
                          job_city: '${doc['job']}_${doc['city']}',
                          rating: doc['reatingavarge'].toDouble(),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'تصنيفات أخرى',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            StreamBuilder<List<Map<String, String>>>(
              stream: fetchAlljobStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد بيانات للعرض'));
                }

                List<Map<String, String>> job = snapshot.data!;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: job.length,
                  itemBuilder: (context, index) {
                    String jobName = job[index]['name']!;
                    String jobImage = job[index]['image']!;

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserJob(job: jobName)));
                      },
                      child: defaultJob(
                        img: jobImage,
                        jobName: jobName,
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Image(image: AssetImage('images/Untitled-23.png')),
                Column(
                  children: [
                    SizedBox(height: hight),
                    Text(
                      '%10',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: sizeFont,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: hight),
                    Text(
                      'من الارباح',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: sizeFont,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 2 * hight),
                    Text(
                      'لدعم شعبنا',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: sizeFont,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: hight),
                    Text(
                      'في قطاع غزة',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: sizeFont,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: hight),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget highestRating({
  required String img,
  required String name,
  required String job_city,
  required double rating,
}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundImage: NetworkImage(img),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          job_city,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
        ),
      ],
    ),
  );
}

Widget defaultJob({
  required String img,
  required String jobName,
}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    padding: EdgeInsets.all(10.0),
    height: 200,
    width: 100,
    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(10.0),

    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: NetworkImage(img),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        Text(
          jobName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 5,
        ),
      ],
    ),
  );
}