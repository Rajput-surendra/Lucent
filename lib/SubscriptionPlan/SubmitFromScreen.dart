import 'dart:convert';

import 'package:doctorapp/New_model/CarWashing/Get_time_model.dart';
import 'package:doctorapp/Screen/Bottom.dart';
import 'package:doctorapp/SubscriptionPlan/bookingDetailsScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../New_model/CarWashing/GetAreaModel.dart';
import '../New_model/CarWashing/GetCityModel.dart';
import '../Screen/HomeScreen.dart';
import '../api/api_services.dart';

class SubmitFromScreen extends StatefulWidget {
  String? planId,amount,title,days ,brandName,modelName;
  bool? Purchased;
  SubmitFromScreen({Key? key,this.planId,this.amount,this.title,this.days,this.Purchased,this.brandName,this.modelName}) : super(key: key);

  @override
  State<SubmitFromScreen> createState() => _SubmitFromScreenState();
}

class _SubmitFromScreenState extends State<SubmitFromScreen> {
  // List<String> timeList = [
  //   '11:00 AM - 11:30 AM',
  //   '11:30 AM  - 12:00 AM',
  //   "12:00 AM  - 12:30 PM",
  //   "12:30 PM - 1:00 PM",
  // ];

  var selectedTime ;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController SocityController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController flatController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();


  Razorpay? _razorpay;
  int? pricerazorpayy;
  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getTimeSlotApi();
    getCityApi();
    getAreaApi(cityId);
  }
  GetTimeModel? getTimeModel;
  getTimeSlotApi() async {
    var headers = {
      'Cookie': 'ci_session=fb2c83fffb21f7e826955b4e041e6a7c89a1baa1'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getTimeSlotApi}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =  await response.stream.bytesToString();
      var finalResult = GetTimeModel.fromJson(jsonDecode(result));
      print("${finalResult}");
      setState(() {
        getTimeModel = finalResult;
      });

      print('____dddddddd______${finalResult}_________');
    }
    else {
    print(response.reasonPhrase);
    }

  }
  GetCityModel? getCityModel;
  getCityApi() async {
    var headers = {
      'Cookie': 'ci_session=3a4cd63b534c683647ea20d9535cede658f91878'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getCitySubApi}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
       var result  = await response.stream.bytesToString();
       var finalResult = GetCityModel.fromJson(json.decode(result));
       print("yyyyyyyyyyyyyyyyyyyyyyyyyy${finalResult}");
       setState(() {
         getCityModel = finalResult;
       });
    }
    else {
    print(response.reasonPhrase);
    }

  }
  GetAreaModel? getAreaModel;
  getAreaApi(cityId) async {
    var headers = {
      'Cookie': 'ci_session=6fce42e0ac17928d8960d147f2e0daf3659ba926'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getAreaSubApi}'));
    request.fields.addAll({
      'city_id': cityId.toString()
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result  = await response.stream.bytesToString();
      var finalResult = GetAreaModel.fromJson(json.decode(result));
      print("yyyyyyyyyyyyyyyyyyyyyyyyyy${finalResult}");
      setState(() {
        getAreaModel = finalResult;
      });
    }
    else {
    print(response.reasonPhrase);
    }

  }
  getplanPurchaseSuccessApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=bd34a0e21152859762f3a4ee6615cbbd5acdcee2'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getPlanPurchasApi}'));
    request.fields.addAll({
      'user_id': userId.toString(),
      'plan_id': widget.planId.toString(),
      'transaction_id': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': widget.amount.toString(),
      'time_slot': '${selectedTime}',
      'name': nameController.text,
      'address': addressController.text,
      'mobile': mobileController.text,
      'block': blockController.text,
      'flot': flatController.text,
      'society': SocityController.text
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var result =   await response.stream.bytesToString();
      final finalResult = json.decode(result);
      setState(() {
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
      Fluttertoast.showToast(msg: finalResult['message']);
    }
    else {
      print(response.reasonPhrase);
    }

  }
  String id = '';
  void openCheckout(amount) async {
    double res = double.parse(amount.toString());
    pricerazorpayy= int.parse(res.toStringAsFixed(0)) * 100;
    print("checking razorpay price ${pricerazorpayy.toString()}");
    print("checking razorpay price ${pricerazorpayy.toString()}");
    // Navigator.of(context).pop();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': "${pricerazorpayy}",
      'name': 'Lucent',
      'image':'assets/splash/splashimages.png',
      'description': 'Lucent',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
      getplanPurchaseSuccessApi();
   // Fluttertoast.showToast(msg: "Subscription added successfully");
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment cancelled by user");
    // setSnackbar("ERROR", context);
    // setSnackbar("Payment cancelled by user", context);
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
  }

  String?cityId;
  String?placeId;
  List <GetCitiesDataNew>getCitiesData = [];
  // List <GetPlacedData>getPlacedData = [];
  int? selectedSateIndex;
  String? selectedCity;
  String? selectedPlace;
  String? address;

  // address = selectedCity + selectedPlace ;
  @override
  Widget build(BuildContext context) {
    print('_____cccccccc_____${widget.modelName}_________');
    print('_____cccccccc_____${widget.brandName}_________');
    return  Scaffold(
      backgroundColor: colors.darkIcon,
      appBar: customAppBar(context: context, text:"Booking", isTrue: true, ),
      body:
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
               padding: const EdgeInsets.all(5.0),
               child: Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Customer Details ",
                         style: TextStyle(
                             color: colors.blackTemp, fontWeight: FontWeight.bold,fontSize: 20),
                       ),
                       SizedBox(height: 10,),
                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Your Name",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       Container(
                         height: 55,
                         decoration: BoxDecoration(
                             color:
                             colors.darkIcon,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           style: TextStyle(color: colors.black54),
                           controller: nameController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                               prefixText: "",
                               hintText: 'Enter Name',
                               hintStyle: const TextStyle(
                                   fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(left: 10, top: 5)),
                           validator: (v) {
                             if (v!.isEmpty) {
                               return "name is required";
                             }
                           },
                         ),
                       ),
                       Padding(
                           padding: const EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               const Text(
                                 "Mobile No",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               const Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )
                       ),
                       Container(
                         height: 55,
                         decoration: BoxDecoration(
                             color:
                             colors.darkIcon,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           style: TextStyle(color: colors.black54),
                           controller: mobileController,
                           keyboardType: TextInputType.number,
                           maxLength: 10,
                           decoration: InputDecoration(
                               counterText: "",
                               hintText: 'Enter Mobile',
                               hintStyle:
                               TextStyle(fontSize: 15.0, color: colors.secondary),
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(left: 10, top: 10)),
                           validator: (v) {
                             if (v!.length != 10) {
                               return "mobile number is required";
                             }
                           },
                         ),
                       ),
                       SizedBox(
                         height: 10,
                       ),
                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "City",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       getCityModel == null || getCityModel ==  ""  ?
                       Text("Load!!!"):  Container(
                         width: MediaQuery.of(context).size.width/1.0,

                         decoration: BoxDecoration(
                           color: colors.darkIcon,
                           borderRadius: BorderRadius.circular(10),

                         ),
                         child: DropdownButtonHideUnderline(
                           child: DropdownButton2<String>(
                             hint: const Text('city',
                               style: TextStyle(
                                   color: colors.primary,fontWeight: FontWeight.w500,fontSize:15
                               ),),
                             // dropdownColor: colors.primary,
                             value: selectedCity,
                             icon:  const Padding(
                               padding: EdgeInsets.only(left:0.0),
                               child: Icon(Icons.keyboard_arrow_down_rounded,  color:colors.secondary,size: 30,),
                             ),
                             // elevation: 16,
                             style:  const TextStyle(color: colors.secondary,fontWeight: FontWeight.bold),
                             underline: Padding(
                               padding: const EdgeInsets.only(left: 0,right: 0),
                               child: Container(
                                 // height: 2,
                                 color:  colors.whiteTemp,
                               ),
                             ),
                             onChanged: (String? value) {
                               // This is called when the user selects an item.
                               setState(() {
                                 selectedCity = value!;
                                 getCityModel!.data!.forEach((element) {
                                   if(element.name == value){
                                     selectedSateIndex = getCityModel!.data!.indexOf(element);
                                     cityId = element.id;
                                     selectedPlace = null;
                                     //addressController.text = "${selectedCity}";
                                     getAreaApi(cityId!);
                                     //getStateApi();
                                   }
                                 });
                               });
                             },
                             items: getCityModel!.data!.map((items) {
                               return DropdownMenuItem(
                                 value: items.name.toString(),
                                 child:  Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top: 5),
                                       child: Container(

                                           child: Padding(
                                             padding: const EdgeInsets.only(bottom: 5),
                                             child: Text(items.name.toString(),overflow:TextOverflow.ellipsis,style: const TextStyle(color:colors.black54),),
                                           )),
                                     ),


                                   ],
                                 ),
                               );
                             })
                                 .toList(),


                           ),

                         ),
                       ),
                       SizedBox(height: 10,),
                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Society",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       getAreaModel == null || getAreaModel ==  ""  ?
                       Text("Load!!!"):   Container(
                         width: MediaQuery.of(context).size.width/1.0,
                         decoration: BoxDecoration(
                           color:colors.darkIcon,
                           borderRadius: BorderRadius.circular(10),

                         ),
                         child: DropdownButtonHideUnderline(
                           child: DropdownButton2<String>(
                             hint: const Text('society',
                               style: TextStyle(
                                   color: colors.primary,fontWeight: FontWeight.w500,fontSize:15
                               ),),
                             // dropdownColor: colors.primary,
                             value: selectedPlace,
                             icon:  const Padding(
                               padding: EdgeInsets.only(left:10.0),
                               child: Icon(Icons.keyboard_arrow_down_rounded,  color:colors.secondary,size: 30,),
                             ),
                             // elevation: 16,
                             style:  const TextStyle(color: colors.secondary,fontWeight: FontWeight.bold),
                             underline: Padding(
                               padding: const EdgeInsets.only(left: 0,right: 0),
                               child: Container(
                                 // height: 2,
                                 color:  colors.whiteTemp,
                               ),
                             ),
                             onChanged: (String? value) {
                               // This is called when the user selects an item.
                               setState(() {
                                 selectedPlace = value!;
                                 getAreaModel!.data!.forEach((element) {
                                   if(element.name == value){
                                     selectedSateIndex = getAreaModel!.data!.indexOf(element);
                                     placeId = element.id;
                                     addressController.text = "${selectedPlace} ${selectedCity}";
                                     //selectedCity = null;
                                     //selectedPlace = null;

                                     print('_____Surdfdgdgendra_____${placeId}_________');
                                     //getStateApi();
                                   }
                                 });
                               });
                             },
                             items: getAreaModel?.data?.map((items) {
                               return DropdownMenuItem(
                                 value: items.name.toString(),
                                 child:  Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top: 5),
                                       child: Container(

                                           child: Padding(
                                             padding: const EdgeInsets.only(bottom: 5),
                                             child: Text(items.name.toString(),overflow:TextOverflow.ellipsis,style: const TextStyle(color:colors.black54),),
                                           )),
                                     ),


                                   ],
                                 ),
                               );
                             })
                                 .toList(),


                           ),

                         ),
                       ),
                       SizedBox(height: 10,),

                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Address",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       Container(
                         height: 55,
                         decoration: BoxDecoration(
                             color:
                             colors.darkIcon,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           style: TextStyle(color: colors.black54),
                           controller: addressController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                               prefixText: "",
                               hintText: 'Enter Address',
                               hintStyle: const TextStyle(
                                   fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(left: 10, top: 10)),
                           validator: (v) {
                             if (v!.isEmpty) {
                               return "address is required";
                             }
                           },
                         ),
                       ),
                       SizedBox(height: 10,),

                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Block Name",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       Container(
                         height: 55,
                         decoration: BoxDecoration(
                             color:
                             colors.darkIcon,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           style: TextStyle(color: colors.black54),
                           controller: blockController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                               prefixText: "",
                               hintText: 'Enter block',
                               hintStyle: const TextStyle(
                                   fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(left: 10, top: 5)),
                           validator: (v) {
                             if (v!.isEmpty) {
                               return "block is required";
                             }
                           },
                         ),
                       ),

                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Flat Number",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )


                       ),
                       Container(
                         height: 55,
                         decoration: BoxDecoration(
                             color:
                             colors.darkIcon,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           style: TextStyle(color: colors.black54),
                           controller: flatController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                               prefixText: "",
                               hintText: 'Enter Flat Number',
                               hintStyle: const TextStyle(
                                   fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(left: 10, top: 5)),
                           validator: (v) {
                             if (v!.isEmpty) {
                               return "Flat Number is required";
                             }
                           },
                         ),
                       ),
                       SizedBox(height: 10,),
                       Padding(
                           padding: EdgeInsets.all(5.0),
                           child:Row(
                             children: [
                               Text(
                                 "Time",
                                 style: TextStyle(
                                     color: colors.black54, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 "*",
                                 style: TextStyle(
                                     color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                               ),
                             ],
                           )

                       ),
                       getTimeModel == null || getTimeModel!.data! == ""  ?Center(child: CircularProgressIndicator()):   Container(
                         height: 50,
                         width: MediaQuery.of(context).size.width,
                         child: ListView.builder(
                             shrinkWrap: true,
                             itemCount:getTimeModel!.data!.length,
                             physics: ScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (c,i){
                               return InkWell(
                                 onTap: (){
                                   setState(() {
                                     selectedTime = getTimeModel!.data![i].slot;
                                   });
                                   print("selected time here  ${selectedTime}");
                                 },
                                 child: Container(
                                   alignment: Alignment.center,
                                   padding: EdgeInsets.symmetric(horizontal: 5),
                                   margin: EdgeInsets.only(right: 10),
                                   decoration: BoxDecoration(
                                     color: selectedTime == getTimeModel!.data![i].slot ? colors.primary : colors.darkIcon,
                                     // width: selectedTime == timeList[i] ? 2 :1

                                     borderRadius: BorderRadius.circular(9),
                                   ),
                                   child: Text("${getTimeModel!.data![i].slot}", style: TextStyle(color:selectedTime == getTimeModel!.data![i].slot ? colors.whiteTemp : colors.primary),),
                                 ),
                               );
                             }),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vehicle Details ",
                          style: TextStyle(
                              color: colors.blackTemp, fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Row(
                              children: [
                                Text(
                                  "Vehicle Model",
                                  style: TextStyle(
                                      color: colors.black54, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                                ),
                              ],
                            )


                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color:
                              colors.darkIcon,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            style: TextStyle(color: colors.black54),
                            controller: modelController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixText: "",
                                hintText: 'Enter Vehicle Model',
                                hintStyle: const TextStyle(
                                    fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10, top: 10)),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Vehicle Model is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Row(
                              children: [
                                Text(
                                  "Vehicle Number",
                                  style: TextStyle(
                                      color: colors.black54, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                                ),
                              ],
                            )


                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color:
                              colors.darkIcon,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            style: TextStyle(color: colors.black54),
                            controller: vehicleNumberController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixText: "",
                                hintText: 'Enter Vehicle Number',
                                hintStyle: const TextStyle(
                                    fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10, top: 10)),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "vehicle Number is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Row(
                              children: [
                                Text(
                                  "Parking",
                                  style: TextStyle(
                                      color: colors.black54, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                                ),
                              ],
                            )


                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color:
                              colors.darkIcon,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            style: TextStyle(color: colors.black54),
                            controller: parkingController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixText: "",
                                hintText: 'Enter Parking',
                                hintStyle: const TextStyle(
                                    fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10, top: 10)),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "parking is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10,),

                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child:Row(
                              children: [
                                Text(
                                  "LandMark",
                                  style: TextStyle(
                                      color: colors.black54, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      color: colors.red, fontWeight: FontWeight.bold,fontSize: 10),
                                ),
                              ],
                            )


                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color:
                              colors.darkIcon,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            style: TextStyle(color: colors.black54),
                            controller: landMarkController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixText: "",
                                hintText: 'Enter landMark',
                                hintStyle: const TextStyle(
                                    fontSize: 15.0, color: colors.primary,fontWeight: FontWeight.normal),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10, top: 10)),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "landMark is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingDetailsScreen(brandName:widget.brandName,modelName:modelController.text
                          ,landMark: landMarkController.text,vihileNumber:  vehicleNumberController.text,
                        Purchased: widget.Purchased,days:widget.days,amount: widget.amount,title:widget.title
                        ,planId:widget.planId,addressC: addressController.text,blockC: blockController.text,flatC: flatController.text,mobileC: mobileController.text,
                      nameC: nameController.text,societyC: selectedCity,timeC:selectedTime,area:selectedPlace,parking: parkingController.text,)));
                      if(selectedTime ==  null || selectedTime == " "){
                        Fluttertoast.showToast(msg: "Please Select Time",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:colors.secondary,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else{

                      }
                    }
                    else{
                      Fluttertoast.showToast(msg: "All Field are required",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor:colors.secondary,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Container(

                    height: 45,
                    decoration: BoxDecoration(
                      color: colors.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,color: colors.whiteTemp,
                          ),
                        ),
                      )


                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
