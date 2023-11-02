import 'dart:convert';

import 'package:doctorapp/Service/serviceScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../New_model/CarWashing/Get_brand_model.dart';
import 'package:http/http.dart'as http;

import '../SubscriptionPlan/subscription_plan.dart';
import '../api/api_services.dart';

class ServiceBrandScreen extends StatefulWidget {
  const ServiceBrandScreen({Key? key}) : super(key: key);

  @override
  State<ServiceBrandScreen> createState() => _ServiceBrandScreenState();
}

class _ServiceBrandScreenState extends State<ServiceBrandScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBrandApi();
  }
  GetBrandModel? getBrandModel;
  getBrandApi() async {
    var headers = {
      'Cookie': 'ci_session=6f6d1e21291ca7058fbe06d969fff0d27d6c98d1'
    };
    var request = http.Request('POST', Uri.parse('${ApiService.getBrandApi}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =  await response.stream.bytesToString();
      var finalResult = GetBrandModel.fromJson(jsonDecode(result));
      print('____finalResult______${finalResult}_________');
      setState(() {
        getBrandModel = finalResult;
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: colors.darkIcon,
          appBar: customAppBar(context: context, text:"Car Type", isTrue: true, ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getBrandModel == null ? Center(child: CircularProgressIndicator()):
                  getBrandModel!.data!.length == 0 ?
                  Center(child: Text("No data Found!!"),):Container(
                    height: MediaQuery.of(context).size.height/1.18,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2,
                        childAspectRatio: 3/3.50
                      ),
                      itemCount: getBrandModel!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPlan(brandId: getBrandModel!.data![index].id,brandName:getBrandModel!.data![index].title ,)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: ClipRRect(
                                   borderRadius: BorderRadius.circular(10),
                                    child: Image.network("${getBrandModel!.data![index].image}",fit: BoxFit.fill,height: MediaQuery.of(context).size.height/5,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(child: Text("${getBrandModel!.data![index].title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]
            ),
          )
      ),
    );
  }
}
