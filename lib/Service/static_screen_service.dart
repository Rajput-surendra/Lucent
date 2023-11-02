
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart'as http;

import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../api/api_services.dart';
import 'Service+BrandScreen.dart';

class StaticScreenService extends StatefulWidget {
  String? name;
   StaticScreenService({Key? key,this.name}) : super(key: key);

  @override
  State<StaticScreenService> createState() => _StaticScreenServiceState();
}

class _StaticScreenServiceState extends State<StaticScreenService> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  Future<Null> _refresh() {
    return callApi();
  }
  Future<Null> callApi() async {
    getStaticApi();
  }
  void initState() {
    super.initState();
    getStaticApi();
  }
  var staticPage;
  var title;
  var images;


  getStaticApi() async {
    var headers = {
      'Cookie': 'ci_session=019fd08d09cd09b3ef17ca74468c0ff182c39982'
    };
    var request = http.MultipartRequest('GET', Uri.parse('${ApiService.getStaticServiceApi}?text=${widget.name.toString()}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result =  await response.stream.bytesToString();
      final jsonResponse = json.decode(result);
      setState(() {
        staticPage = jsonResponse['setting']['car_service_details'];
        title = jsonResponse['setting']['title'];
        images = jsonResponse['setting']['image'];
      });

    }
    else {
      print(response.reasonPhrase);
    }

  }
  // getStaticApi() async {
  //   var headers = {
  //     'Cookie': 'ci_session=a9e2b2b5babf936a50d21f49a14599f3dfd707aa'
  //   };
  //   var request = http.Request('GET', Uri.parse('${ApiService.getStaticServiceApi}'));
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     final result =  await response.stream.bytesToString();
  //     final jsonResponse = json.decode(result);
  //     setState(() {
  //       staticPage = jsonResponse['setting']['car_service_details'];
  //       title = jsonResponse['setting']['title'];
  //       images = jsonResponse['setting']['image'];
  //     });
  //
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  //
  // }
  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        bottomSheet: InkWell(
          onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceBrandScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: colors.primary,borderRadius: BorderRadius.circular(10)),
              height: 50,
              child: Center(child: Text("Book Service",style: TextStyle(color: colors.whiteTemp),)),
            ),
          ),
        ),
          appBar:  customAppBar(text: "Lucent",isTrue: true, context: context),
          body:staticPage == null || staticPage == "" ?Center(child: CircularProgressIndicator()):ListView(
            children: [
              // images == null || images == "" ?Center(child: Text("Load Images!!!")) :
              Container(
                width: double.infinity,
                height: 250,
                child: Image.network("${images}",fit: BoxFit.fill,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 5),
                child: Text(title,style: TextStyle(fontSize: 20,color: colors.blackTemp,fontWeight: FontWeight.bold),),
              ),
              staticPage == null || staticPage == "" ? Center(child: CircularProgressIndicator()) :
              Html(
                  data:staticPage
              ),
              SizedBox(height: 50,)
            ],
          )
      ),
    );
  }
}

