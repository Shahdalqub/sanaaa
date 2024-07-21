
import 'package:flutter/material.dart';
double size=15;
Widget defaultFormField( {
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  required String? Function(String?)? validate,

  required Widget prefix,
  void Function() ? suffpass,
  bool isPasword=false,
  Widget? suffix =null,
  bool isClickable=true,
})=>Container(
  color: Colors.grey.shade200,
  width: 230.0,
  child: TextFormField(
    controller: controller,
    onFieldSubmitted: onSubmit,
    onChanged: onChanged,
    onTap: onTap,
    obscureText: isPasword,
    enabled: isClickable,
    keyboardType: type,
    decoration: InputDecoration(
        fillColor: Color.fromRGBO(225, 225, 225, 1),
        filled: true,
  // hintText: 'Email Address',
     // labelText: label,
      prefixIcon: prefix,
      suffixIcon:suffix != null ? IconButton(onPressed:suffpass,
          icon: suffix) :null ,
      //border:OutlineInputBorder(),

    ),
    validator: validate,
  ),
);
Widget defaultJob({
  required String img,
  required String jobName,
})=>Container(
  width: 90.0,
  child: Column(

    children: [
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage(
              img
            ),
          ),


        ],
      ),
      SizedBox(
        height:10.0 ,
      ),
      Text(
        jobName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
);
Widget highestRating({
   required String img,
  required String name,
  required String job_city,
})=>Card(
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50.0,
          child:  Image(
              image: AssetImage(
              img
              ),
            //fit: BoxFit.cover,
          ),

        ),
        Text(name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
        Text(job_city,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey
        ),),
        Row(
          children: [
            Icon(Icons.star,
            size:size,
            color: Colors.yellow,),
            Icon(Icons.star,
              size:size,
              color: Colors.yellow,),
            Icon(Icons.star,
              size:size,
              color: Colors.yellow,),
            Icon(Icons.star,
              size:size,
              color: Colors.yellow,),
            Icon(Icons.star,
              size:size,
              color: Colors.yellow,),
          ],
        ),

      ],
    ),
  ),
);

