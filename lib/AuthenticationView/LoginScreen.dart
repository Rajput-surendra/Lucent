

import 'dart:convert';
import 'package:doctorapp/Screen/Bottom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../Helper/Color.dart';
import '../New_model/login_response.dart';
import 'Signup.dart';
import '../api/api_services.dart';
import 'VerifyOtp.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key,this.id}) : super(key: key);
  final id;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _value = 1;
  bool isMobile = false;
  bool isSendOtp = false;
  bool isLoading = false;
  bool isloader = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LogInResponse? logInResponse ;

  int selectedIndex = 1;
  bool _isObscure = true;

  bool islodder = false;
  loginWithMobileApi() async {
    setState(() {
      islodder =  true;
    });
    String? token ;
    try{
      token  = await FirebaseMessaging.instance.getToken();
      print("-----------token:-----${token}");
    } on FirebaseException{
      print('__________FirebaseException_____________');
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('otp', "otp");
    preferences.setString('mobile', "mobile");
    print("this is apiiiiiiii");
    var headers = {
      'Cookie': 'ci_session=3463c437a12b70be3d42ff97fbb888c49cf6887f'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.sendOTP}'));
    request.fields.addAll({
      'mobile': mobileController.text,
      'fcm_id' : '${token}'
    });
     print('____request.fields______${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonresponse = json.decode(finalResponse);
      print("this is final responsesssssssssss${finalResponse}");
      if (jsonresponse['status'] == true) {
        String otp = jsonresponse['data'][0]['otp'];
        String mobile = jsonresponse['data'][0]['mobile'];
        print('____App_________${mobile}__${otp}___');
        Fluttertoast.showToast(msg: '${jsonresponse['message']}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyOtp(OTP: otp,MOBILE:mobile,)
        ));
        // setState(() {
        //   islodder =  false;
        // });
      }
      else{
        setState(() {
          isloader =  false;
        });
        Fluttertoast.showToast(msg: "${jsonresponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  bool isLoading1 = false;
  @override
  void initState()  {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token){
      print("token is print-------------> $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: colors.primary),
                      child: Text("YES"),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: colors.primary),
                      child: Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
          return true;
        },
        child: Scaffold(
          backgroundColor:  colors.darkIcon,
          bottomSheet: Container(
            color: colors.darkIcon,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?",style: TextStyle(color: colors.blackTemp,fontSize: 14,fontWeight: FontWeight.bold),),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                }, child: Text("SignUp",style: TextStyle(color: colors.secondary,fontSize: 16,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/backlogin.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 250,
                      child: Image.asset("assets/splash/splashimages.png",scale: 6.6,)),
                  Align(

                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                          child: Column(
                            mainAxisSize:  MainAxisSize.min,
                            children: [
                              SizedBox(height: 20,),
                              Text("Welcome to Lucent",style: TextStyle(color: colors.primary
                                ,fontWeight: FontWeight.bold,fontSize: 18,),),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("Login",style: TextStyle(color: colors.primary
                                        ,fontWeight: FontWeight.bold,fontSize: 18,),),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 10, vertical: 10),
                                    //   child: Container(
                                    //     height: 60,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(15),
                                    //       color: colors.whiteTemp,
                                    //       //Theme.of(context).colorScheme.gray,
                                    //     ),
                                    //     child: Card(
                                    //       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    //       elevation: 0,
                                    //       child: Center(
                                    //         child: TextFormField(
                                    //           controller: mobileController,
                                    //           keyboardType: TextInputType.number,
                                    //           maxLength: 10,
                                    //           validator: (v) {
                                    //             if (v!.length != 10) {
                                    //               return "mobile number is required";
                                    //             }
                                    //           },
                                    //           decoration: InputDecoration(
                                    //
                                    //             border: OutlineInputBorder(
                                    //               borderSide: BorderSide(
                                    //                 color: colors.primary
                                    //               ),
                                    //               borderRadius: BorderRadius.circular(20),
                                    //
                                    //             ),
                                    //             counterText: "",
                                    //             contentPadding:
                                    //             EdgeInsets.only(left: 15, top: 15),
                                    //             hintText: "Mobile Number",hintStyle: TextStyle(color: colors.secondary),
                                    //             prefixIcon: Icon(
                                    //               Icons.call,
                                    //               color:colors.secondary,
                                    //               size: 20,
                                    //             ),
                                    //
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                          color: colors.darkIcon1,),
                                        child: TextFormField(
                                          style: TextStyle(color: colors.black54),
                                          controller: mobileController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              hintText: 'Enter mobile',
                                              hintStyle: TextStyle(
                                                  fontSize: 15.0, color: colors.secondary),
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.only(left: 10, top: 0)),
                                          validator: (v) {
                                            if (v!.length < 10) {
                                              return "mobile number is required";
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, left: 50, right: 50),
                                        child:
                                        InkWell(
                                            onTap: (){
                                              setState((){
                                                isLoading = true;
                                              });
                                              if(mobileController.text.isNotEmpty && mobileController.text.length == 10){
                                                loginWithMobileApi();
                                              }else{
                                                setState((){
                                                  isLoading = false;
                                                });
                                                Fluttertoast.showToast(msg: "Please enter valid mobile number!");
                                              }
                                            },
                                            child:  Container(
                                              height: 50,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: colors.secondary),
                                              child:
                                              isloader  ? Center(child: CircularProgressIndicator(color: Colors.white,),) :
                                              Center(child: Text("Send OTP", style: TextStyle(fontSize: 18, color: colors.whiteTemp))),
                                            )
                                        )

                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

