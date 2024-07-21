import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'; // Import the package

class Suggest_page extends StatefulWidget {
  @override
  _Suggest_pageState createState() => _Suggest_pageState();
}

class _Suggest_pageState extends State<Suggest_page> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PS'); // Initialize PhoneNumber with Palestine code
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    // Dispose of any controllers or streams that are no longer needed
    nameController.dispose();
    topicController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> addSuggestion() async {
    String name = nameController.text;
    String topic = topicController.text;
    String details = detailsController.text;
    String phone = phoneNumber.phoneNumber ?? '';

    if (name.isEmpty || phone.isEmpty || topic.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Get a reference to the user's subcollection within the "users" collection
      CollectionReference suggestionsRef = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('suggestions');

      // Add a new document with suggestion data
      await suggestionsRef.add({
        'name': name,
        'phone': phone,
        'topic': topic,
        'details': details,
        'submittedAt': DateTime.now(), // Timestamp for sorting/filtering
      });

      // Clear text fields after successful submission
      nameController.clear();
      topicController.clear();
      detailsController.clear();


      // Reset phone number
      setState(() {
        phone='';
        phoneNumber = PhoneNumber(isoCode: 'PS');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Suggestion submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          // Matches the background color of the body
          elevation: 0,
          // Removes the shadow under the app bar
          centerTitle: true,
          title: Text(
            'الاقتراحات',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
            // Specifies the icon and color
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Pops the current route off the navigation stack
            },
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[800],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32),
                _buildTextField(nameController, 'الاسم'),
                SizedBox(height: 16),
                _buildPhoneField(),
                SizedBox(height: 16),
                _buildTextField(topicController, 'موضوع الاقتراح'),
                SizedBox(height: 16),
                _buildLargeTextField(detailsController, 'تفاصيل الاقتراح'),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.arrow_forward, size: 24),
                      label: Text('إرسال'),
                      onPressed: () {
                        addSuggestion();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        setState(() {
          phoneNumber = number;
        });
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: phoneNumber,
      formatInput: true,
      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
      inputDecoration: InputDecoration(
        labelText: 'رقم الهاتف',
        labelStyle: TextStyle(color: Colors.grey[500]),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
      ),
      inputBorder: _buildOutlineInputBorder(),
      selectorTextStyle: TextStyle(color: Colors.black),
    );
  }

  Widget _buildLargeTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        fillColor: Colors.white,
        filled: true,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.orange,
        width: 2.5,
      ),
    );
  }
}
