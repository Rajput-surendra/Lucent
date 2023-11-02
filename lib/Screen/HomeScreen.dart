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
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? videoPlayerController;

  bool? isPlaying ;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController?.dispose();
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  SpeciplyData? localFilter;
  int currentindex = 0;

  GetUserProfileModel? getprofile;
  getuserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=d9075fff59f39b7a82c03ca267be8899c1a9fbf8'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiService.getUserProfile}'));
    request.fields.addAll({'id': '$userId'});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
      GetUserProfileModel.fromJson(json.decode(finalResult));
      setState(() {
        getprofile = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

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
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
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

      final finalResult = GetSliderModel.fromJson(json.decode(result));

      setState(() {
        _sliderModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }

  }

  void initState() {
    super.initState();
    // videoPlayerController = VideoPlayerController.network(
    //     "https://lucentservices.in/uploads/car-vedio.mp4");
    // videoPlayerController!.initialize();
    // videoPlayerController!.setLooping(false);
    // videoPlayerController!.play();
    getAccessoriesApi();
    Future.delayed(const Duration(milliseconds: 300), () {
      return getSliderApi();


    });
    getSliderApi();
    Future.delayed(const Duration(milliseconds: 200), () {
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
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     var  result = await response.stream.bytesToString();
     var finalResult = CheckPlanModel.fromJson(jsonDecode(result));
     if(finalResult.status == true){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPosterScreen()));
     }else{
       Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPlan()));
     }
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
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =  await response.stream.bytesToString();
      var finalResult = AccessoriesModel.fromJson(jsonDecode(result));
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
                title: const Text("Confirm Exit"),
                content: const Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: colors.primary),
                    child: const Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: colors.primary),
                    child: const Text("NO"),
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
          backgroundColor: colors.whiteTemp,
          key: _key,
          //appBar: customAppBar(context: context, text:"My Dashboard", isTrue: true, ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 7,right: 5),
                child: Column(
                  children: [
                    getSlider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService()));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:  colors.whiteTemp,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 160,
                                  child: Column(
                                    children: [
                                      Image.asset("assets/splash/service.png",height: 120,width: 150,),
                                      const Text("Service",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold,fontSize: 18))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandScreen()));
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Accessories()));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                                child: Container(
                                  // width:165,
                                  decoration: BoxDecoration(
                                      color:  colors.whiteTemp,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 160,
                                  child: Column(

                                    children: [
                                      Image.asset("assets/splash/asse.png",height: 120,width: 150),
                                      const Text("Accessories",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold,fontSize: 18))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    carStaticWidget(),
                    const SizedBox(height: 15,),
                    homeStaticImages(),
                    getStaticWidget(),

                    const SizedBox(height: 10,),

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
            margin: const EdgeInsets.all(1.5),
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
  getSlider(){
    return  Column(
      // alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
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
    );
  }
  getStaticWidget(){
    return  Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child:
              Container(
                  child: Image.asset("assets/images/settingHome.png"))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Select Your Service",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
                      color:  colors.primary
                  ),),
                  SizedBox(height: 3,),
                  Text("Select Your Car Cleaning Services",style: TextStyle(fontSize: 16),),
                  //Text("Home Cleaning or Washroom Cleaning",style: TextStyle(fontSize: 14.3),),
                ],
              ),
            ],
          ),
          const SizedBox(height: 0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 0,),
                  Text(" Choose Your Time Slot",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,
                    color:  colors.primary
                  ),
                  ),
                  SizedBox(height: 3,),
                  Text(" Choose from the available time slots \n And Confirm the booking.",style: TextStyle(fontSize: 15),),

                ],
              ),
              const SizedBox(width: 5,),
              Image.asset("assets/images/timeslot.png"),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image.asset("assets/images/hassle.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hassel-Free Service",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
                        color: colors.primary
                    ),),
                    SizedBox(height: 3,),
                    Text("Once booking is confirmed, our \nprofessional will visit at your doorstep  \nwill serve you ",style: TextStyle(fontSize: 14),),

                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
  carStaticWidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: "Waterless Cleaning",)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 110 ,
                              color: colors.darkIcon,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset("assets/splash/car.jpg",fit: BoxFit.fill)),
                              ))),
                      const SizedBox(height: 5,),
                      const Center(child: Text("Waterless Cleaning",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),))
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7,),

              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: 'Deep Cleaning',)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Container(
                            color: colors.darkIcon,
                            height: 110 ,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset("assets/splash/car1.jpg",fit: BoxFit.fill,)),
                            )),
                        const SizedBox(height: 5,),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Monthly Deep \n   Cleaning",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: 'Engine Cleaning',)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                            color: colors.darkIcon,
                            height: 110 ,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset("assets/splash/car3.jpg",fit: BoxFit.fill,)),
                            )),
                        const SizedBox(height: 5,),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Monthly Engine \n   Cleaning",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: 'Exterior Polishing',)));
                  },
                  child: Column(
                    children: [
                      Container(
                          color: colors.darkIcon,
                          height: 110 ,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/splash/car2.jpg",fit: BoxFit.fill,)),
                          )),
                      const SizedBox(height: 5,),
                      const Text("Weekly Car Exterior\n      Polishing ",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: 'Glass Cleaner Liquid Top-Up',)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                color: colors.darkIcon,
                                height: 110 ,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset("assets/splash/car4.jpg",fit: BoxFit.fill,)),
                                ))),  const SizedBox(height: 5,),

                        const Text("Weekly Glass Cleaner \n        Liquid Top-up",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticScreenService(name: 'Interior Cleaning')));
                  },
                  child: Column(
                    children: [
                      Container(
                          color: colors.darkIcon,
                          height: 110 ,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/splash/car5.jpg",fit: BoxFit.fill,)),
                          )),
                      const SizedBox(height: 5,),
                      const Center(child: Text("Monthly Interior \n     Cleaning",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 11),))
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

      ],
    );
  }
  homeStaticImages(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Save Time ",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 18),),
          const SizedBox(height: 5,),
          const Text("Hours of your precious time are wasted driving, queuing and washing your car at your local services. At Waterless cleaning, we come to you. Get those precious hours back at the click of a button.",textAlign: TextAlign.justify,),
          const SizedBox(height: 5,),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/lucent1.jpg")),
          const SizedBox(height: 20,),
          const Text("Save Money",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 18),),
          const SizedBox(height: 5,),
          const Text("Our competitive pricing, alongside our mobile approach, aims to save each of our customers money.",textAlign: TextAlign.justify,),
          const SizedBox(height: 10,),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/luent2.jpg")),
          const SizedBox(height: 20,),
          const Text("Save Water",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 18),),
          const SizedBox(height: 5,),
          const Text("Each Dropless wash saves our customers over 150 litres of water. Using nano solutions that break down and encapsulate dirt our skilled operators give your car that perfect shine again.",textAlign: TextAlign.justify,),
          const SizedBox(height: 10,),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/lueent3.jpg")),
        ],
      ),
    );
  }
}
