import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snaapro/mudeuls/createAccunte/create_account_screen.dart';
import 'package:snaapro/mudeuls/login%20page/loginPage.dart';

//void main() {
// runApp(const MyApp());
//}
class firstPage extends StatefulWidget{
  const firstPage({super.key});
  _firstPage createState() => _firstPage();

}
class _firstPage extends State<firstPage>{
  bool colstate1=false;
  bool colstate2=false;
  Color c=Color.fromRGBO(255,116,49,1);
  Color cb=Color.fromRGBO(240, 240, 240, 1);
  @override
  Widget build(BuildContext context) {

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          SystemNavigator.pop();
        },

        child: MaterialApp(

            debugShowCheckedModeBanner:false,
            home: Scaffold(
              backgroundColor: Color.fromRGBO(234, 234, 234, 1),

              body: Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height:80,
                      ),
                      const CircleAvatar(
                        backgroundImage:AssetImage('images/Untitled-1.png') ,
                        //child: Image.asset("images/start.jpeg", fit: BoxFit.contain,),
                        radius: 70.0,

                      ),

                      const Text("صَنعة ",style:TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'coconnextarabic',
                      ),),
                      SizedBox(
                        height:60,
                      ),
                      MaterialButton(
                        onPressed: (){
                          setState(() {
                            colstate1=true;
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginPage()));
                          });
                        }, child: const Text("تسجيل الدخول",style:TextStyle(
                          fontSize:28,
                          fontFamily:"coconnextarabic"
                      ),),color:colstate1?c:cb,
                        textColor:Colors.black,

                        minWidth:250 ,
                        height:50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(
                        height:20,
                      ),
                      MaterialButton(
                        onPressed: (){

                          setState(() {
                            colstate2=true;
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateAccount()));
                          });
                        },color:colstate2?c:cb,
                        textColor:Colors.black,
                        minWidth:250 ,
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ), child: const Text("انشاء حساب",style:TextStyle(
                        fontSize: 28,
                        fontFamily:"coconnextarabic",
                      ),),

                      ),

                      Container(
                          width: 350,
                          height: 350,
                          alignment:Alignment.bottomCenter,
                          child: Image.asset("images/Untitled-2.png",height: 300, width: 300, alignment:Alignment.bottomCenter, )),

                    ],

                  )
              ),
            )));
  }//

}