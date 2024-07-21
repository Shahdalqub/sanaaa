import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String userimage;
  final String userid;

  const ChatScreen({
    Key? key,
    required this.username,
    required this.userimage,
    required this.userid,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream =
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final TextEditingController _textController = TextEditingController();

  Future<File?> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void _showOptionsDialog(DocumentSnapshot messageDocument) {
    bool isCurrentUser =
        messageDocument['senderid'] == FirebaseAuth.instance.currentUser!.uid;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خيارات الرسالة"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCurrentUser)
                _buildOptionButton("تعديل", () {
                  Navigator.pop(context);
                  _showEditDialog(messageDocument);
                }),
              _buildOptionButton("نسخ", () {
                Navigator.pop(context);
                _copyMessage(messageDocument.get('message'));
              }),
              if (isCurrentUser)
                _buildOptionButton("حذف", () {
                  Navigator.pop(context);
                  _deleteMessage(messageDocument);
                }),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsDialog2(DocumentSnapshot messageDocument) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خيارات الرسالة"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOptionButton("نسخ", () {
                Navigator.pop(context);
                _copyMessage(messageDocument.get('message'));
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(String title, Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }

  void _showEditDialog(DocumentSnapshot messageDocument) {
    String updatedMessage = messageDocument.get('message');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تعديل الرسالة"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: updatedMessage,
                onChanged: (value) {
                  updatedMessage = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                _updateMessage(messageDocument, updatedMessage);
                Navigator.of(context).pop();
              },
              child: Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  void _updateMessage(DocumentSnapshot messageDocument, String updatedMessage) {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(chatroomid())
        .collection('messagessh')
        .doc(messageDocument.id)
        .update({
      'message': updatedMessage,
    });
  }

  void _deleteMessage(DocumentSnapshot messageDocument) {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(chatroomid())
        .collection('messagessh')
        .doc(messageDocument.id)
        .delete();
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم نسخ الرسالة")),
    );
  }

  void _sendImageMessage(String imageUrl) async {
    final uuid = Uuid().v4();
    final now = Timestamp.now();

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatroomid())
        .collection('messagessh')
        .doc(uuid)
        .set(
      {
        'message': '',
        'imageUrl': imageUrl,
        'senderid': FirebaseAuth.instance.currentUser!.uid,
        'date': now,
        'messageid': uuid
      },
      SetOptions(merge: true),
    );

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatroomid())
        .update({
      'lastMessage': 'صورة',
      'date': now,
    });
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('${Uuid().v4()}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  String chatroomid() {
    List users = [FirebaseAuth.instance.currentUser!.uid, widget.userid];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: documentStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final userName = data['name'];
          String image1 = data['image'];

          return Scaffold(
            backgroundColor: Color.fromRGBO(234, 234, 234, 1),
            appBar: AppBar(
              backgroundColor: Colors.grey[350],
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userimage),
                  ),
                  SizedBox(width: 8),
                  Text("${widget.username}"),
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .doc(chatroomid())
                          .collection('messagessh')
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final messages = snapshot.data!.docs;
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> messagemap =
                            messages[index].data() as Map<String, dynamic>;
                            String currentid =
                                FirebaseAuth.instance.currentUser!.uid;
                            String senderid = messagemap['senderid'];
                            bool isImageMessage =
                                messagemap['imageUrl'] != null;
                            return GestureDetector(
                              onTap: () {
                                if (currentid == senderid) {
                                  _showOptionsDialog(messages[index]);
                                } else {
                                  _showOptionsDialog2(messages[index]);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Align(
                                  alignment: currentid == senderid
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    child: isImageMessage
                                        ? Image.network(
                                      messagemap['imageUrl'],
                                      width: 200,
                                      height: 200,
                                    )
                                        : Text(
                                      messagemap['message'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: currentid == senderid
                                          ? Colors.orange
                                          : Colors.grey[600]!,
                                      border: Border.all(
                                          color: Colors.deepOrangeAccent),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.deepOrangeAccent,
                          width: 2,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.deepOrangeAccent),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                controller: _textController,
                                onChanged: (value) {},
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  hintText: "ارسل هنا",
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.photo),
                                    color: Colors.deepOrangeAccent,
                                    onPressed: () async {
                                      File? image = await _pickImage();
                                      if (image != null) {
                                        String imageUrl =
                                        await _uploadImage(image);
                                        _sendImageMessage(imageUrl);
                                      }
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_textController.text.isNotEmpty) {
                                        final message = _textController.text;
                                        final timestamp = Timestamp.now();
                                        final uuid = Uuid().v4();
                                        await FirebaseFirestore.instance
                                            .collection('chat')
                                            .doc(chatroomid())
                                            .set({
                                          'sendername': userName,
                                          'senderimage': image1,
                                          'senderid': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'recivername': widget.username,
                                          'reciverimage': widget.userimage,
                                          'reciverid': widget.userid,
                                          'participants': [
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.userid
                                          ],
                                          'chatroomid': chatroomid(),
                                          'date': timestamp,
                                          'lastMessage': message,
                                          'lastMessageDate': timestamp,
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('chat')
                                            .doc(chatroomid())
                                            .collection('messagessh')
                                            .doc(uuid)
                                            .set({
                                          'message': _textController.text,
                                          'senderid': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'date': Timestamp.now(),
                                          'messageid': uuid
                                        });
                                      }
                                      setState(() {
                                        _textController.text = "";
                                      });
                                    },
                                    icon: Icon(Icons.send),
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
