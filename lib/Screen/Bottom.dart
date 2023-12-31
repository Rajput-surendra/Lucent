import 'dart:convert';

import 'package:doctorapp/Profile/profile_screen.dart';
import 'package:doctorapp/Screen/Histroy.dart';
import 'package:doctorapp/Screen/HomeScreen.dart';
import 'package:doctorapp/Screen/WishlistScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthenticationView/LoginScreen.dart';
import '../Booking/booking_screen.dart';
import '../Enquiry/enquiry_List_Screen.dart';
import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../New_model/getUserProfileModel.dart';
import '../Notification/notification.dart';
import '../Profile/Update_password.dart';
import '../Static/contact_us_screen.dart';
import '../Static/privacy_Policy.dart';
import '../Static/terms_condition.dart';
import '../SubscriptionPlan/SubscriptionPlanList.dart';
import '../SubscriptionPlan/subscription_plan.dart';
import '../api/api_services.dart';
import 'package:http/http.dart'as http;

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int currentindex = 0;
  List<Widget> pages1 = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      currentindex = index;
    });
  }
  bool profileLodder = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserProfile();
  }
  GetUserProfileModel? getprofile;
  getuserProfile() async {
    setState(() {
      profileLodder =true;
    });
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
        profileLodder = false;
      });
    } else {
      setState(() {
        profileLodder = false;
      });
      print(response.reasonPhrase);
    }
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
                    style: ElevatedButton.styleFrom(primary: colors.secondary),
                    child: const Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(primary: colors.secondary),
                    child: const Text("NO"),

                  )
                ],
              );
            });

        return true;
      },
      child: SafeArea(
        child: Scaffold(
         drawer: profileLodder ? const Center(child: CircularProgressIndicator()) :getDrawer(),
          appBar: AppBar(
            titleSpacing: -20,
            iconTheme: const IconThemeData(color:colors.blackTemp),
            backgroundColor:colors.whiteTemp,
            title: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Image.asset("assets/ssssss.png",height: 50,width: 80,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: (){
                    // Fluttertoast.showToast(msg: "Working in Progress");
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationList()));
                  },
                    child: const Icon(Icons.notifications_active,color: colors.blackTemp,)),
              )
            ],
          ),
          body: Center(
            child: pages1.elementAt(currentindex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: colors.primary,
            //  elevation: 1,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  label: 'Home', icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: 'Profile', icon: Icon(Icons.people_alt_sharp)),
            ],
            currentIndex: currentindex,
            selectedItemColor: colors.whiteTemp,
            unselectedItemColor: colors.whiteTemp.withOpacity(0.6),
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: 13,
            selectedFontSize: 13,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
  getDrawer() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.3,
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [colors.primary, colors.secondary],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // main
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                  getprofile?.data?.first.profilePic ?? '',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 160,
                            child: Text(
                              getprofile?.data?.first.username ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis,),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          getprofile?.data?.first.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colors.white10,
                  colors.primary,
                ],
              ),
            ),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Image.asset(
                  "assets/splash/home.png",
                  color: colors.primary,
                  scale: 1.9,
                  height: 35,
                  width: 35,
                ),
              ),
              title: const Text(
                'Home',
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (Context) => const BottomScreen()));

              },
            ),
          ),


          ListTile(
            leading: Image.asset(
              "assets/splash/inquiry.png",
              color: colors.primary,
              height: 30,
              width: 30,
            ),
            title: const Text(
              'My Bookings',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>const SubmitEnquiryListScreen()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/splash/subsciption.png",
              color: colors.primary,
              height: 25,
              width: 25,
            ),
            title: const Text(
              'My Subscription Plan',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionPlanScreen()),
              );
            },
          ),

          ListTile(
            leading: Image.asset(
              "assets/splash/terrns and condition.png",
              height: 25,
              width: 25,
              color: colors.primary,
            ),
            title: const Text(
              'Terms & Conditions',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsCondition()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/splash/privacy policy.png",
              color: colors.primary,
              height: 25,
              width: 25,
            ),
            title: const Text(
              'Privacy Policy',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/splash/contectus.png",
              color: colors.primary,
              height: 25,
              width: 25,
            ),
            title: const Text(
              'Contact Us',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),

          ListTile(
            leading: Image.asset(
              "assets/images/DELETE.png",
            color: colors.primary,
              height: 25,
              width: 25,
            ),
            title: const Text(
              'Delete Account',
            ),
            onTap: () {
              deleteAccountDailog();
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => HomeScreen()),
              //   );
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/Sign Out.png",
              color: colors.primary,
              height: 35,
              width: 30,
              //color: Colors.grey.withOpacity(0.8),
            ),
            title: const Text(
              'Sign Out',
            ),
            onTap: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Sign out"),
                      content: const Text("Are you sure you want to Sign out?"),
                      actions: <Widget>[
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(primary: colors.primary),
                          child: const Text("YES"),
                          onPressed: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            setState(() {
                              prefs.clear();
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(primary: colors.primary),
                          child: const Text("NO"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
  dialogAnimate(BuildContext context, Widget dialge) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: dialge),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // pageBuilder: null
        pageBuilder: (context, animation1, animation2) {
          return Container();
        } //as Widget Function(BuildContext, Animation<double>, Animation<double>)
    );
  }
  deleteAccountDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: const Text(
                      "Are you sure you want to delete?",
                      style: TextStyle(color: colors.primary)
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: const Text( "NO",style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    TextButton(
                        child:  const Text( "YES",style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          deleteAccount();
                          Navigator.of(context).pop(false);
                        })
                  ],
                );
              });
        }));
  }

  deleteAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userID = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=96944ca78b243ab8f0408ccfec94c5f2d8ca05fc'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.deleteApi}'));
    request.fields.addAll({
      'user_id': userID.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult =  jsonDecode(result);
      Fluttertoast.showToast(msg: "${finalResult['message']}",backgroundColor: colors.secondary);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    else {
      print(response.reasonPhrase);
    }

  }
}
