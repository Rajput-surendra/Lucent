import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctorapp/AuthenticationView/LoginScreen.dart';
import 'package:doctorapp/Booking/booking_screen.dart';
import 'package:doctorapp/Brand/BrandScreen.dart';
import 'package:doctorapp/Helper/Color.dart';
import 'package:doctorapp/Screen/Histroy.dart';
import 'package:doctorapp/Static/privacy_Policy.dart';
import 'package:doctorapp/api/api_services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Accessrioes/AccessoriesDetailsScreen.dart';
import '../Accessrioes/Accessrioes.dart';
import '../Awreness/Awareness_Inputs_screen.dart';
import '../Editorial/editorial.dart';
import '../Event/event_and_webiner.dart';
import '../New_model/CarWashing/Accessories_model.dart';
import '../New_model/Check_plan_model.dart';
import '../New_model/GetCountingModel.dart';
import '../New_model/GetSelectCatModel.dart';
import '../New_model/GetSliderModel.dart';
import '../New_model/getUserProfileModel.dart';
import '../Profile/Update_password.dart';
import '../Profile/profile_screen.dart';
import '../Service/Service+BrandScreen.dart';
import '../Service/serviceScreen.dart';
import '../Service/static_screen_service.dart';
import '../SubscriptionPlan/addPosterScreen.dart';
import '../SubscriptionPlan/subscription_plan.dart';
import '../widgets/widgets/commen_slider.dart';
import '../Product/Pharma_product_screen.dart';
import 'WishlistScreen.dart';

import '../Static/terms_condition.dart';
import '../News/update_screen.dart';
import 'filte_speciality.dart';

class HomeScreen extends StatefulWidget {
  final bool? speciality;
  const HomeScreen({
    Key? key, this.speciality
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  SpeciplyData? localFilter;
  int currentindex = 0;

  GetUserProfileModel? getprofile;
  getuserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    print("getProfile--------------->${userId}");
    var headers = {
      'Cookie': 'ci_session=d9075fff59f39b7a82c03ca267be8899c1a9fbf8'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiService.getUserProfile}'));
    request.fields.addAll({'id': '$userId'});
    print("getProfile--------------->${request.fields}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
      GetUserProfileModel.fromJson(json.decode(finalResult));
      print("this is a ========>profile${jsonResponse}");
      print("emailllllll${getprofile?.data?.first.mobile}");
      setState(() {
        getprofile = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  // GetUserProfileModel? getprofile;
  // getuserProfile() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? userId = preferences.getString('userId');
  //   print("getProfile--------------->${userId}");
  //   var headers = {
  //     'Cookie': 'ci_session=d9075fff59f39b7a82c03ca267be8899c1a9fbf8'
  //   };
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('${ApiService.getUserProfile}'));
  //   request.fields.addAll({'user_id': '$userId'});
  //   print("getProfile--------------->${request.fields}");
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var finalResult = await response.stream.bytesToString();
  //     final jsonResponse =
  //         GetUserProfileModel.fromJson(json.decode(finalResult));
  //     print("this is a ========>profile${jsonResponse}");
  //     print("emailllllll${getprofile?.user?.mobile}");
  //     setState(() {
  //       getprofile = jsonResponse;
  //     });
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  // GetSelectCatModel? selectCatModel;
  // getCatApi() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? Roll = preferences.getString('roll');
  //   String? userId = preferences.getString('userId');
  //   print("getRoll--------------->${Roll}");
  //
  //   var headers = {
  //     'Cookie': 'ci_session=742f7d5e34b7f410d122da02dbbe7e75f06cadc8'
  //   };
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('${ApiService.selectCategory}'));
  //   request.fields.addAll({'roll': '1', 'cat_type': "2", 'user_id': '$userId'});
  //   print("this is a Response==========>${request.fields}");
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     //preferences.setString('id', "Id");
  //     final result = await response.stream.bytesToString();
  //     final finalResult = GetSelectCatModel.fromJson(jsonDecode(result));
  //     print('_____Surendra _____${finalResult}_________');
  //
  //     setState(() {
  //       selectCatModel = finalResult;
  //     });
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  _CarouselSlider1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        options: CarouselOptions(
            onPageChanged: (index, result) {
              setState(() {
                _currentPost = index;
              });
            },
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            height: 200.0),
        items: _sliderModel!.data!.map((item) {
          return CommonSlider(file: item.image ?? '',);
        }).toList(),
      ),
    );
  }

  GetSliderModel? _sliderModel;
  getSliderApi() async {
    var headers = {
      'Cookie': 'ci_session=ccb37a117d31b04c006884a89fbff3d1a39bffd7'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getSlider}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print("this is a response===========>${result}");
      final finalResult = GetSliderModel.fromJson(json.decode(result));
      print("this is a response===========>${finalResult}");
      setState(() {
        _sliderModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }

  }

  void initState() {
    super.initState();
    getAccessoriesApi();
    print("this is my speiality  ${widget.speciality}");
    Future.delayed(Duration(milliseconds: 300), () {
      return getSliderApi();

    });
    getSliderApi();
    Future.delayed(Duration(milliseconds: 200), () {
      return getuserProfile();

    });

    if(widget.speciality == true){
      setState(() {

      });
    }
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<Null> _refresh() {
    return callApi();
  }
  Future<Null> callApi() async {
     // getuserProfile();
    getSliderApi();
    getAccessoriesApi();

  }
  CheckPlanModel? checkPlanModel;
  checkSubscriptionApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=64caa747045713fca2e42eb930c7387e303fd583'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getCheckSubscriptionApi}'));
    request.fields.addAll({
      'user_id': "$userId",
    });
    print('___sadsfdsfsdfsdafgsdgdg_______${request.fields}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     var  result = await response.stream.bytesToString();
     var finalResult = CheckPlanModel.fromJson(jsonDecode(result));
     if(finalResult.status == true){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPosterScreen()));
     }else{
       Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPlan()));
     }
     print('____Bew Api______${finalResult}_________');
     setState(() {
      checkPlanModel =  finalResult ;
     });
    }
    else {
    print(response.reasonPhrase);
    }

  }

  AccessoriesModel? accessoriesModel;
  getAccessoriesApi() async {
    var headers = {
      'Cookie': 'ci_session=6bcc4535837660e175a6b14cc70b96bd495eeca0'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getAccessoriesApi}'));
    request.fields.addAll({
    });
    print('___sdgdfgds_______${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =  await response.stream.bytesToString();
      var finalResult = AccessoriesModel.fromJson(jsonDecode(result));
      print('____finalResult______${finalResult}_________');
      setState(() {
        accessoriesModel = finalResult;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  setFilterDataId( String id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('LocalId', id );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scaffold(
          backgroundColor: colors.whiteScaffold,
          key: _key,
          //appBar: customAppBar(context: context, text:"My Dashboard", isTrue: true, ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 7,right: 5),
                child: Column(
                  children: [
                    Column(
                      // alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          //height: 200,
                          width: double.maxFinite,
                          child: _sliderModel == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: colors.primary,
                                ))
                              : _CarouselSlider1(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildDots(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>StaticScreenService()));
                              },
                              child: Container(
                               width:165,
                                decoration: BoxDecoration(
                                    color:  colors.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                height: 170,
                                child: Column(
                                  children: [
                                    Image.asset("assets/splash/service.png",height: 120,width: 100,),
                                    Text("Service",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandScreen()));
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Accessories()));
                              },
                              child: Container(
                                // width:165,
                                decoration: BoxDecoration(
                                    color:  colors.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                height: 170,
                                child: Column(
                                  children: [
                                    Image.asset("assets/splash/asse.png",height: 120,width: 100),
                                    Text("Accessories",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    getStaticWidget(),
                    SizedBox(height: 10,)
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //       children: [
                    //         accessoriesModel == null ? Center(child: CircularProgressIndicator()): accessoriesModel!.data!.length == 0 ?
                    //         Center(child: Text("No data Found!!"),):Container(
                    //           child: ListView.builder(
                    //             shrinkWrap: true,
                    //            physics: NeverScrollableScrollPhysics(),
                    //             itemCount: accessoriesModel!.data!.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               return InkWell(
                    //                 onTap: (){
                    //                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessoriesDetailsSrreen(id: accessoriesModel!.data![index].id,)));
                    //                 },
                    //                 child: Card(
                    //                     shape: RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(10)
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         Padding(
                    //                           padding: const EdgeInsets.all(8.0),
                    //                           child: Container(
                    //                               height: 90,
                    //                               width: 90,
                    //                               decoration: BoxDecoration(
                    //                                   borderRadius: BorderRadius.circular(10)
                    //                               ),
                    //                               child: ClipRRect(
                    //                                   borderRadius: BorderRadius.circular(10),
                    //                                   child: Image.network("${accessoriesModel!.data![index].logo}",fit: BoxFit.fill,))),
                    //                         ),
                    //                         SizedBox(height: 15,),
                    //                         Column(
                    //                           crossAxisAlignment: CrossAxisAlignment.start,
                    //                           children: [
                    //                             Container(
                    //                               width: 190,
                    //                                 child: Text("${accessoriesModel!.data![index].name}"
                    //                               ,style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                    //                             SizedBox(height: 2,),
                    //                             Container(
                    //                                 width: 190,
                    //                                 child: Text("${accessoriesModel!.data![index].description}",overflow: TextOverflow.ellipsis,maxLines: 2,))
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     )
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         )
                    //       ]
                    //   ),
                    // )


                    // SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _currentPost = 0;

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    if (_sliderModel == null) {
    } else {
      for (int i = 0; i < _sliderModel!.data!.length; i++) {
        dots.add(
          Container(
            margin: EdgeInsets.all(1.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPost == i ? colors.primary : colors.blackTemp,
            ),
          ),
        );
      }
    }
    return dots;
  }
  getStaticWidget(){
    return  Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        height: MediaQuery.of(context).size.height/2.0,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child:
                  Container(
                      child: Image.asset("assets/images/settingHome.png"))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8,),
                      Text("Select Your Service",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
                          color:  colors.primary
                      ),),
                      SizedBox(height: 3,),
                      Text("Select the service you wish to desire",style: TextStyle(fontSize: 14),),
                      Text("Home Cleaning or Washroom Cleaning",style: TextStyle(fontSize: 14.3),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25,),
                      Text("Choose Your Time Slot",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
                        color:  colors.primary
                      ),
                      ),
                      SizedBox(height: 3,),
                      Text("Choose from the available time slots and\n confirm  the booking."),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 50),
                      //   child: Text(""),
                      // ),
                    ],
                  ),
                  SizedBox(width: 5,),
                  Image.asset("assets/images/timeslot.png"),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.width/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Image.asset("assets/images/hassle.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hassel-Free Service",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
                            color: colors.primary
                        ),),
                        SizedBox(height: 3,),
                        Text("Once booking is confirmed, our \n professional will visit at your doorstep  \n will serve you ",style: TextStyle(fontSize: 14),),

                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}
