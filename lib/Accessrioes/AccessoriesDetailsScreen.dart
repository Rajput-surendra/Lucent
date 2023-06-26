import 'dart:convert';

import 'package:doctorapp/New_model/CarWashing/Accessories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../Enquiry/enquire_Screen.dart';
import '../api/api_services.dart';

class AccessoriesDetailsSrreen extends StatefulWidget {
  String? id;
   AccessoriesDetailsSrreen({Key? key,this.id}) : super(key: key);
  @override
  State<AccessoriesDetailsSrreen> createState() => _AccessoriesDetailsSrreenState();
}
class _AccessoriesDetailsSrreenState extends State<AccessoriesDetailsSrreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccessoriesApi();
  }
  AccessoriesModel? accessoriesModel;
  getAccessoriesApi() async {
    var headers = {
      'Cookie': 'ci_session=6bcc4535837660e175a6b14cc70b96bd495eeca0'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiService.getAccessoriesApi}'));
    request.fields.addAll({
      'id': widget.id.toString()
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
    return Scaffold(
      bottomSheet: Container(
        color: colors.darkIcon,
        child: InkWell(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EnquireScreen(accessoriesId: accessoriesModel!.data!.first.id)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colors.primary
              ),
              child: Center(child: Text("Enquiry",style: TextStyle(color: colors.whiteTemp),)),
            ),
          ),
        ),
      ),
      backgroundColor: colors.darkIcon,
      appBar: customAppBar(context: context, text:"Accessories Details", isTrue: true, ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:accessoriesModel== null || accessoriesModel== ""? Center(child: CircularProgressIndicator()) :Container(
          height: MediaQuery.of(context).size.height/1.3,
          decoration: BoxDecoration(
            color: colors.whiteTemp,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Container(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: Image.network("${accessoriesModel!.data!.first.logo}",height: 220,fit: BoxFit.fill,)),
                    ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(height: 5,),
                             Text("Name:"),
                             SizedBox(height: 5,),

                             Text("Model"),
                             SizedBox(height: 5,),
                             Text("Brand"),
                             SizedBox(height: 5,),

                           ],
                         ),
                         Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Text("${accessoriesModel!.data!.first.name}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text("${accessoriesModel!.data!.first.model}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text("${accessoriesModel!.data!.first.brand}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),

                            ],
                          )
                       ],
                     ),
                   ),
                Text("Description"),
                SizedBox(height: 5,),
                  Container(

                    child: Text("${accessoriesModel!.data!.first.description}",maxLines: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold))),
                // Text("${accessoriesModel!.data!.first.description}")
              ],
            ),
          ),
        ),
      ),

    );
  }
}
