import 'dart:convert';
import 'dart:io';
import 'package:doctorapp/AuthenticationView/LoginScreen.dart';
import 'package:doctorapp/Helper/Color.dart';
import 'package:doctorapp/New_model/registration_model2.dart';
import 'package:doctorapp/api/api_services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helper/AppBtn.dart';
import 'package:http/http.dart' as http;
class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key,}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;
  File? imageFile;
  File? newImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  RegistrationModel2? detailsData;
  registrationApi() async {
    setState(() {
   isLoading == true;
    });
    var headers = {
      'Cookie': 'ci_session=dd50c278f09355c16fbac67ed21dae08884302f4'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.userRegister}'));
    request.fields.addAll({
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
    });
    print('____request.fields______${request.fields}_________');

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
     var result =  await response.stream.bytesToString();
     var finalResult =  jsonDecode(result);
     print("${finalResult}");
     if(finalResult['status'] == true){
       Fluttertoast.showToast(msg: finalResult['message']);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
       nameController.clear();
       emailController.clear();
       mobileController.clear();
     }else{
       Fluttertoast.showToast(msg: finalResult['message']);

     }
     setState(() {
       isLoading = false;
     });

    }
    else {
      setState(() {
        isLoading = false;
      });
      print(response.reasonPhrase);
    }

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
            height: 93,
            color: colors.darkIcon,
            child: Column(
              children: [
                Center(
                  child: Btn(
                      height: 45,
                      width: 320,
                      title:
                      isLoading ? "Please wait......" : 'Submit',
                      color: colors.secondary,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          registrationApi();
                        } else {
                          const snackBar = SnackBar(
                            content: Text('All Fields are required!'),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?",style: TextStyle(color: colors.blackTemp,fontSize: 14,fontWeight: FontWeight.bold),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    }, child: Text("Login",style: TextStyle(color: colors.secondary,fontSize: 16,fontWeight: FontWeight.bold),))
                  ],
                ),
              ],
            )

          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/backlogin.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                        alignment: Alignment.center,
                        height: 120,
                        child: Image.asset("assets/splash/splashimages.png",scale: 6.2,)),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 100,bottom: 20),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisSize:  MainAxisSize.min,
                            children: [
                              SizedBox(height: 20,),
                              Text("SignUp",style: TextStyle(color: colors.primary
                                ,fontWeight: FontWeight.bold,fontSize: 18,),),
                               Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Your Name",
                                                    style: TextStyle(
                                                        color: colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                        color: colors.red,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                              color: colors.darkIcon,),

                                            child: TextFormField(
                                              style: TextStyle(color: colors.black54),
                                              controller: nameController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Enter name',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 15.0, color: colors.secondary),
                                                  contentPadding:
                                                  EdgeInsets.only(left: 10, top: 0)),
                                              validator: (v) {
                                                if (v!.isEmpty) {
                                                  return "name is required";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    "Mobile No",
                                                    style: TextStyle(
                                                        color: colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const Text(
                                                    "*",
                                                    style: TextStyle(
                                                        color: colors.red,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                                color: colors.darkIcon,),
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Email Id",
                                                    style: TextStyle(
                                                        color: colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                        color: colors.red,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                              color: colors.darkIcon,),
                                            child: TextFormField(
                                              style: TextStyle(color: colors.black54),
                                              controller: emailController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  hintText: 'Enter email',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 15.0, color: colors.secondary),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                  EdgeInsets.only(left: 10, top: 0)),
                                              validator: (v) {
                                                if (v!.isEmpty) {
                                                  return "Email is required";
                                                }
                                                if (!v.contains("@")) {
                                                  return "Enter Valid Email Id";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),


                                        ]
                                    ),
                                  )
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


    //   Scaffold(
    //     bottomSheet: Container(
    //       color: colors.darkIcon,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text("Already have an account?",style: TextStyle(color: colors.blackTemp,fontSize: 14,fontWeight: FontWeight.bold),),
    //           TextButton(onPressed: (){
    //             Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    //           }, child: Text("Login",style: TextStyle(color: colors.secondary,fontSize: 16,fontWeight: FontWeight.bold),))
    //         ],
    //       ),
    //     ),
    //   backgroundColor: colors.darkIcon,
    //     appBar: customAppBar(text: "SignUp", isTrue: true, context: context),
    //     body: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //         child: SingleChildScrollView(
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Form(
    //                   key: _formKey,
    //                   child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                             padding: EdgeInsets.all(5.0),
    //                             child: Row(
    //                               children: [
    //                                 Text(
    //                                   "Your Name",
    //                                   style: TextStyle(
    //                                       color: colors.black54,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 Text(
    //                                   "*",
    //                                   style: TextStyle(
    //                                       color: colors.red,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 10),
    //                                 ),
    //                               ],
    //                             )),
    //                         Container(
    //                           height: 55,
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    //                             color: colors.whiteTemp,),
    //
    //                           child: TextFormField(
    //                             style: TextStyle(color: colors.black54),
    //                             controller: nameController,
    //                             keyboardType: TextInputType.emailAddress,
    //                             decoration: InputDecoration(
    //                                 border: InputBorder.none,
    //                                 hintText: 'Enter name',
    //                                 hintStyle: const TextStyle(
    //                                     fontSize: 15.0, color: colors.secondary),
    //                                 contentPadding:
    //                                     EdgeInsets.only(left: 10, top: 5)),
    //                             validator: (v) {
    //                               if (v!.isEmpty) {
    //                                 return "name is required";
    //                               }
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         Padding(
    //                             padding: const EdgeInsets.all(5.0),
    //                             child: Row(
    //                               children: [
    //                                 const Text(
    //                                   "Mobile No",
    //                                   style: TextStyle(
    //                                       color: colors.black54,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 const Text(
    //                                   "*",
    //                                   style: TextStyle(
    //                                       color: colors.red,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 10),
    //                                 ),
    //                               ],
    //                             )),
    //                         Container(
    //                           height: 55,
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    //                             color: colors.whiteTemp,),
    //                           child: TextFormField(
    //                             style: TextStyle(color: colors.black54),
    //                             controller: mobileController,
    //                             keyboardType: TextInputType.number,
    //                             maxLength: 10,
    //                             decoration: InputDecoration(
    //                                 counterText: "",
    //                                 hintText: 'Enter mobile',
    //                                 hintStyle: TextStyle(
    //                                     fontSize: 15.0, color: colors.secondary),
    //                                 border: InputBorder.none,
    //                                 contentPadding:
    //                                     EdgeInsets.only(left: 10, top: 5)),
    //                             validator: (v) {
    //                               if (v!.length < 10) {
    //                                 return "mobile number is required";
    //                               }
    //                             },
    //                           ),
    //                         ),
    //                         const SizedBox(
    //                           height: 10,
    //                         ),
    //                         Padding(
    //                             padding: EdgeInsets.all(5.0),
    //                             child: Row(
    //                               children: [
    //                                 Text(
    //                                   "Email Id",
    //                                   style: TextStyle(
    //                                       color: colors.black54,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 Text(
    //                                   "*",
    //                                   style: TextStyle(
    //                                       color: colors.red,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 10),
    //                                 ),
    //                               ],
    //                             )),
    //                         Container(
    //                           height: 55,
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    //                             color: colors.whiteTemp,),
    //                           child: TextFormField(
    //                             style: TextStyle(color: colors.black54),
    //                             controller: emailController,
    //                             keyboardType: TextInputType.emailAddress,
    //                             decoration: InputDecoration(
    //                                 hintText: 'Enter email',
    //                                 hintStyle: const TextStyle(
    //                                     fontSize: 15.0, color: colors.secondary),
    //                                 border: InputBorder.none,
    //                                 contentPadding:
    //                                     EdgeInsets.only(left: 10, top: 5)),
    //                             validator: (v) {
    //                               if (v!.isEmpty) {
    //                                 return "Email is required";
    //                               }
    //                               if (!v.contains("@")) {
    //                                 return "Enter Valid Email Id";
    //                               }
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         Padding(
    //                             padding: EdgeInsets.all(5.0),
    //                             child: Row(
    //                               children: [
    //                                 Text(
    //                                   "Address",
    //                                   style: TextStyle(
    //                                       color: colors.black54,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 Text(
    //                                   "*",
    //                                   style: TextStyle(
    //                                       color: colors.red,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 10),
    //                                 ),
    //                               ],
    //                             )),
    //                         Container(
    //                           height: 55,
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
    //                             color: colors.whiteTemp,),
    //                           child: TextFormField(
    //                             controller: addressController,
    //                             decoration: InputDecoration(
    //                               hintText: 'Enter Address',
    //                                 hintStyle: const TextStyle(
    //                                     fontSize: 15.0, color: colors.secondary),
    //                               border: InputBorder.none,
    //                               contentPadding: EdgeInsets.only(left: 10,top: 5)
    //                             ),
    //                             onTap:(){
    //                               // _getLocation();
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 50,),
    //                         Center(
    //                           child: Btn(
    //                               height: 50,
    //                               width: 320,
    //                               title:
    //                                   isLoading ? "Please wait......" : 'Submit',
    //                               color: colors.secondary,
    //                               onPress: () {
    //                                 if (_formKey.currentState!.validate()) {
    //                                   registrationApi();
    //                                 } else {
    //                                   const snackBar = SnackBar(
    //                                     content: Text('All Fields are required!'),
    //                                   );
    //                                   ScaffoldMessenger.of(context)
    //                                       .showSnackBar(snackBar);
    //                                   //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    //                                 }
    //                               }),
    //                         )
    //                       ]
    //                   )
    //               ),
    //             )
    //         )
    //     )
    // );
  }

}
