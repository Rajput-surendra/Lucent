import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import 'package:http/http.dart'as http;

import '../Helper/Constant.dart';
import '../New_model/CarWashing/Get_Promo_code_Model.dart';
import '../Screen/Bottom.dart';
import '../api/api_services.dart';
import 'CommonWebView.dart';
import 'Plan_Success_Srreen.dart';

class BookingDetailsScreen extends StatefulWidget {
  String? planId,amount,title,days ,brandName,modelName,nameC,societyC,
      flatC,blockC,mobileC,addressC,timeC,area,landMark,vihileNumber,parking;
  bool? Purchased;
  BookingDetailsScreen({Key? key,this.planId,this.amount,this.title,this.days,this.Purchased,this.brandName,
    this.modelName,this.addressC,this.blockC,this.flatC,
    this.mobileC,this.nameC,this.societyC,this.timeC,this.area,this.landMark,this.parking,this.vihileNumber}) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {

  Razorpay? _razorpay;
  int? pricerazorpayy;
  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getPromoCodeApi();
    genratePaytmApi();

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
      'amount': changePrice ? disCountAmount:widget.amount,
      'time_slot': widget.timeC.toString(),
      'name': widget.nameC.toString(),
      'address': widget.addressC.toString(),
      'mobile': widget.mobileC.toString(),
      'block': widget.blockC.toString(),
      'flot': widget.flatC.toString(),
      'society': widget.societyC.toString(),
      "model": widget.modelName.toString(),
      "vehicle_number":widget.vihileNumber.toString(),
      "parking":widget.parking.toString(),
      "landmark":widget.landMark.toString(),
      "coupon_code": promocouponC.text,
      "discount":finalTotal.toString(),
      "subtotal": widget.amount.toString()

    });
    print('______sfcssdf____${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var result =   await response.stream.bytesToString();
      final finalResult = json.decode(result);
      setState(() {
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PlanSuccessScreen()));
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
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment cancelled by user");
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
  }



  var contactUs;
  var privacyPolicyTitle;
  TextEditingController promocouponC =  TextEditingController();

    var finalTotal;
    var linkPaytm;
    var midPaytm;
    var orderIdPaytm;
    var disCountAmount;
    String? couponCode;
    bool changePrice = false;
    genratePaytmApi() async {
      SharedPreferences preferences =  await  SharedPreferences.getInstance();
      String? userId = preferences.getString('userId');
      var headers = {
        'Cookie': 'ci_session=99749a41e7b75ea164826fc3f427082d5d8d9b39'
      };
      var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getGeneratePaytmApi}'));
      request.fields.addAll({
        'amount': changePrice ? disCountAmount:widget.amount,
        'order_id': '2000',
        'user_id': userId.toString()
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final result =  await response.stream.bytesToString();
        final jsonResponse = json.decode(result);
        setState(() {
          linkPaytm = jsonResponse['body']['callbackUrl'];
          midPaytm = jsonResponse['body']['mid'];
          orderIdPaytm = jsonResponse['body']['orderId'];
        });
        print('_____sdsdsdsads_____${linkPaytm}_________');
      }
      else {
      print(response.reasonPhrase);
      }


    }
    checkPromoCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=0cb9ee2fd0d29a541816f5fd12f9e0cb40f01025'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.checkPromoCodeApi}'));
    request.fields.addAll({
       'user_id':userId.toString(),
      'code':promocouponC.text,
      'amount': widget.amount.toString()
    });
    print('_____checkPromoCode_____${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
     var  result =  await response.stream.bytesToString();
     var finalResult =  jsonDecode(result);
      Fluttertoast.showToast(msg: "${finalResult['msg']}");
     setState(() {
       finalTotal = finalResult['data']['discount_amount'];
       disCountAmount = finalResult['data']['amount_after_discount'];
       changePrice = true;
     });
    }
    else {

    print(response.reasonPhrase);
    }

  }
  GetPromoCodeModel ? getPromoCodeModel;
  getPromoCodeApi( ) async {
    var headers = {
      'Cookie': 'ci_session=0bea62107d42e7a22b6f4f536f8aab0e1ae87c3b'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getPromoCodeApi}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
     var result =  await response.stream.bytesToString();
     var finalResult =  GetPromoCodeModel.fromJson(json.decode(result));
     setState(() {
       getPromoCodeModel =  finalResult;
     });
     print('_____checkPromoCode_____${finalResult}_________');
    }
    else {
    print(response.reasonPhrase);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.darkIcon,
      appBar: customAppBar(context: context, text:"Booking Summary", isTrue: true, ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                vehicleDetails(),
                SizedBox(height: 10,),
                planType(),
                SizedBox(height: 10,),
                custumerDetails(),
                SizedBox(height: 20,),
                finalTotal == null ||  finalTotal == ""?SizedBox.shrink():  Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10,)
                        ,color: colors.whiteTemp),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sub Total :"),
                              SizedBox(height: 3,),
                              Text("Discount Price :"),
                              SizedBox(height: 3,),
                              Text("Final Total:"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("₹ ${widget.amount}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
                              SizedBox(height: 3,),
                           Row(
                             children: [
                               Text(" - ")  ,
                               Text("₹ ${finalTotal}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
                             ],
                           ),
                              SizedBox(height: 3,),
                              Text("₹ ${disCountAmount}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2,),
                getPromoCodeModel ==  null || getPromoCodeModel == "" ?CircularProgressIndicator()   :changePrice ? SizedBox.shrink():  getPromoCodeModel!.data!.length > 0 ? applyPromoCode() : SizedBox.shrink(),

                Container(
                  color: colors.darkIcon,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                    child: InkWell(
                      onTap: () async {
                        // _launchURL();
                        // _startPayment(context);
                        // await PaytmConfig().generateTxnToken(double.parse(widget.amount.toString()), orderIdPaytm);
                        // _startTransaction(finalTotal,linkPaytm);
                     //    // generateTxnToken(linkPaytm);
                     // // initiateTransaction("orderId",double.parse(widget.amount!),"txnToken",);
                        if(changePrice){
                          openCheckout(disCountAmount);
                        }else{
                          openCheckout(widget.amount);
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
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  changePrice ? Text("Total : ₹ ${disCountAmount}",style: TextStyle(
                                    fontWeight: FontWeight.bold,color: colors.whiteTemp,
                                  ),):Text("Total : ₹ ${widget.amount}" ,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,color: colors.whiteTemp,
                                    ),
                                  ),
                                  Text("PROCEED TO PAY",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,color: colors.whiteTemp,
                                    ),
                                  ),
                                ],
                              )
                            )


                        ),
                      ),
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
  // final FlutterAppAuth appAuth = FlutterAppAuth();
  // _launchURL() async {
  //   const url = 'https://mercury-t2.phonepe.com/transact/pg?token=MDFhZjIxZjExOWE0MDQwMTgzYjI1MTdkNGMxYmRiNjVhMDIwNzExYWM2NmNlYzFjN2U1MDlmMDU0Mjc5ODMxMWVhOTk0MzA1ODRlN2Q3OGM5ZjJjNjYyMWZhOjdlZTBmNjM4YTA1YTZlNTQ1MzMwMmJhNzIxMTgyMDBj';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  //
  // Future<void> handleRedirect() async {
  //   final AuthorizationTokenResponse? response =
  //   await appAuth.authorizeAndExchangeCode(
  //     AuthorizationTokenRequest(
  //       'your_client_id', // Replace with your client ID
  //       'your_redirect_uri', // Replace with your redirect URI
  //       serviceConfiguration: AuthorizationServiceConfiguration(
  //          // Replace with PhonePe authorization endpoint URL
  //          authorizationEndpoint: 'token_endpoint_url', tokenEndpoint: 'authorization_endpoint_url', // Replace with PhonePe token endpoint URL
  //       ),
  //     ),
  //   );
  //
  //   // Process the payment response
  //   // Extract necessary information from response.accessToken or response.additionalParameters
  // }


  vehicleDetails(){
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle Details",style: TextStyle(color: colors.blackTemp,fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Brand:"),
                      SizedBox(height: 5,),
                      Text("Model Number :"),
                      SizedBox(height: 5,),
                      Text("Vehicle Number :"),
                      SizedBox(height: 5,),
                      Text("Parking Number :"),
                      SizedBox(height: 5,),
                      Text("Landmark :"),
                      SizedBox(height: 5,),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 25,),
                      Text("${widget.brandName}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.modelName}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.vihileNumber}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.parking}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.landMark}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  planType(){
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Plan Type",style: TextStyle(color: colors.blackTemp,fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Name:"),
                      SizedBox(height: 5,),
                      Text("Amount:"),
                      SizedBox(height: 5,),
                      Text("Duration:"),
                      SizedBox(height: 5,),


                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 25,),
                      Text("${widget.title}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.amount}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.days}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),

                    ],
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  custumerDetails(){
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer Details",style: TextStyle(color: colors.blackTemp,fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Name:"),
                      SizedBox(height: 5,),
                      Text("Mobile No:"),
                      SizedBox(height: 5,),

                      Text("City:"),
                      SizedBox(height: 5,),
                      Text("Society"),
                      SizedBox(height: 5,),
                      Text("Address:"),
                      SizedBox(height: 5,),
                      Text("Flat No:"),
                      SizedBox(height: 5,),
                      Text("Block:"),
                      SizedBox(height: 5,),
                      Text("Time:"),
                      SizedBox(height: 5,),



                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 25,),
                      Text("${widget.nameC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.mobileC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.societyC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.area}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.addressC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.flatC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.blockC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("${widget.timeC}",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),

                    ],
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  applyPromoCode(){
    return Padding(
      padding: const EdgeInsets.only(right: 5,left: 5),
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 10,
        decoration: BoxDecoration(
            border: Border.all(color: colors.primary, width: 1,),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white54
          //color: Colors.white54
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: TextField(
                  readOnly: true,
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                return  Container(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: getPromoCodeModel!.data!.length,
                                      itemBuilder:
                                      (context ,index){
                                    return  Container(
                                        height: 80,
                                        child:  Card(
                                          elevation: 5,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Promo Code :",style: TextStyle(color: colors.blackTemp),),
                                                          SizedBox(height: 5,),
                                                          Text("Discount Price :",style: TextStyle(color: colors.blackTemp,fontSize: 15),)
                                                        ],
                                                      ),
                                                      Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${getPromoCodeModel!.data![index].code}",style: TextStyle(color: colors.blackTemp),),
                                                          SizedBox(height: 5,),
                                                          Text("₹ ${getPromoCodeModel!.data![index].discount}",style: TextStyle(color: colors.blackTemp),)
                                                        ],
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(right: 5,top: 10),
                                                          child:InkWell(
                                                            onTap: (){
                                                              promocouponC.text = getPromoCodeModel!.data![index].code ?? "";
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              height: 35,
                                                              width: 120,
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: colors.primary),
                                                              child: Center(child: Text('Add PromoCode',style: TextStyle(color: colors.whiteTemp),)),
                                                            ),
                                                          )

                                                      ),


                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),

                                                ],
                                              )
                                          ),
                                        )

                                    );
                                  }),
                                );
                              });
                        });
                  },
                  controller: promocouponC,
                  maxLines: 1,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Have You PromoCode ...'
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child:InkWell(
                  onTap: (){
                    if( promocouponC.text.isEmpty){
                      Fluttertoast.showToast(msg: "Select PromoCode!!");
                    }else{
                      checkPromoCode();
                    }

                  },
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: colors.primary),
                    child: Center(child: Text('Apply',style: TextStyle(color: colors.whiteTemp),)),
                  ),
                )

            ),

          ],
        ),
      ),
    );
  }
  void _startPayment(BuildContext context) async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    double amount = 100.0; // Replace with your desired amount

    await PaytmPayment.startTransaction(orderId, amount, context);
  }


}


class PaytmPayment {
  static const String merchantId = 'hvdQiD63153182059850';
  static const String merchantKey = 'eHW4uuBUOHG1IiJr';
  static const String channelId = 'WAP';
  static const String website = 'WEBSTAGING';
  static const String callbackUrl =
      'https://mercury-t2.phonepe.com/transact/pg?token=OWE5N2E0OTQwMDEyOTg3NjlhMTQyMjdmYzUxMjFjODYwNjhlYTE2N2EwMjk3MDcxOWRkYjc4NDI2YmZjMzI3ZWE5MTBiZmQ3MjJiNmFiNzJkZTExOjFlZTFmNWViMWQzNDMxMmUyY2MxMzkwN2NhMGUyODhk';

  static Future<void> startTransaction(
      String orderId, double amount, BuildContext context) async {
    var paytmParams = {
      'MID': "hvdQiD63153182059850",
      'ORDER_ID': 3000,
      'CUST_ID': 'CUSTOMER_ID',
      'CHANNEL_ID': channelId,
      'TXN_AMOUNT': "300",
      'WEBSITE': website,
      'INDUSTRY_TYPE_ID': 'Retail   ',
      'CALLBACK_URL': "https://mercury-t2.phonepe.com/transact/pg?token=OWE5N2E0OTQwMDEyOTg3NjlhMTQyMjdmYzUxMjFjODYwNjhlYTE2N2EwMjk3MDcxOWRkYjc4NDI2YmZjMzI3ZWE5MTBiZmQ3MjJiNmFiNzJkZTExOjFlZTFmNWViMWQzNDMxMmUyY2MxMzkwN2NhMGUyODhk",
    };
    var paytmUrl = 'https://securegw.paytm.in/theia/processTransaction';
    var response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebView(
          initialUrl: '$paytmUrl?${jsonEncode(paytmParams)}',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );

    // Process the response received from Paytm
    if (response != null && response['STATUS'] == 'TXN_SUCCESS') {
      // Payment success
      print('Payment success');
    } else {
      // Payment failed
      print('Payment failed');
    }
  }

}

