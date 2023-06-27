import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../New_model/CarWashing/Accessories_model.dart';
import '../New_model/CarWashing/Accessories_model.dart';
import '../New_model/CarWashing/Get_brand_model.dart';
import '../api/api_services.dart';
import '../Brand/Model_Screen.dart';
import 'package:http/http.dart'as http;

import '../Enquiry/enquire_Screen.dart';
import 'AccessoriesDetailsScreen.dart';

class Accessories extends StatefulWidget {
  String? modelId;
      Accessories({Key? key,this.modelId}) : super(key: key);

  @override
  State<Accessories> createState() => _AccessoriesState();
}

class _AccessoriesState extends State<Accessories> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccessoriesApi();
  }
  List<AccessoriesModel>? accessoriesListModel;
  AccessoriesModel? accessoriesModel;
  getAccessoriesApi() async {
    var headers = {
      'Cookie': 'ci_session=6bcc4535837660e175a6b14cc70b96bd495eeca0'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getAccessoriesApi}'));
    request.fields.addAll({
      // 'model_id': widget.modelId.toString()
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: colors.darkIcon,
          appBar: customAppBar(context: context, text:"Accessories", isTrue: true, ),
          body:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                children: [
                  accessoriesModel == null ? Center(child: CircularProgressIndicator()): accessoriesModel!.data!.length == 0 ?
                  Center(child: Text("No data Found!!"),):Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    child: ListView.builder(
                      itemCount: accessoriesModel!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessoriesDetailsSrreen(id: accessoriesModel!.data![index].id,)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                      Row(
                                        children: [
                                          Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network("${accessoriesModel!.data![index].logo}",fit: BoxFit.fill,))),
                                          SizedBox(width: 5,),
                                          Column(
                                            children: [
                                              Container(
                                                  width: 137,
                                                  child: Text("${accessoriesModel!.data![index].name}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                              SizedBox(height: 5,),
                                              Container(
                                                  width: 137,
                                                  child: Text("${accessoriesModel!.data![index].description}",overflow: TextOverflow.ellipsis,maxLines: 2,))
                                            ],
                                          ),
                                        ],
                                      ),
                                    // SizedBox(height: 15,),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EnquireScreen(accessoriesId: accessoriesModel!.data![index].id,)));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: colors.primary
                                        ),
                                        child: Center(child: Text("Book Now",style: TextStyle(color: colors.whiteTemp),)),
                                      ),
                                    )

                                  ],
                                ),
                              )
                          ),
                        );
                      },
                    ),
                  )
                ]
            ),
          )
      )
    );
  }
}
