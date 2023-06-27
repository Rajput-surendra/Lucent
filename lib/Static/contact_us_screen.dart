import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart'as http;

import '../Helper/Appbar.dart';
import '../Helper/Color.dart';
import '../api/api_services.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  Future<Null> _refresh() {
    return callApi();
  }
  Future<Null> callApi() async {
    getPrivacyPolicyApiApi();
  }
  void initState() {
    super.initState();
    getPrivacyPolicyApiApi();
  }
  var contactUs;
  var privacyPolicyTitle;
  getPrivacyPolicyApiApi() async {
    var headers = {
      'Cookie': 'ci_session=0972dd56b7dcbe1d24736525bf2ee593c03d46de'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getContactUsApi}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result =  await response.stream.bytesToString();
      final jsonResponse = json.decode(result);
      setState(() {
        contactUs = jsonResponse['setting']['html'];
        privacyPolicyTitle = jsonResponse['setting']['title'];
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
          appBar:  customAppBar(text: "Contact Us",isTrue: true, context: context),
          body:contactUs == null || contactUs == "" ?Center(child: CircularProgressIndicator()): ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 5),
                child: Text(privacyPolicyTitle,style: TextStyle(fontSize: 16,color: colors.blackTemp,fontWeight: FontWeight.bold),),
              ),
              contactUs == null || contactUs == "" ? Center(child: CircularProgressIndicator()) :
              Html(
                  data:contactUs
              )
            ],
          )
      ),
    );
  }
}
