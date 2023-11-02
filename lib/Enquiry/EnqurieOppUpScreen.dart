import 'package:doctorapp/Screen/Bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Helper/Color.dart';

class EnqurieDetails extends StatefulWidget {
  const EnqurieDetails({Key? key}) : super(key: key);

  @override
  State<EnqurieDetails> createState() => _EnqurieDetailsState();
}

class _EnqurieDetailsState extends State<EnqurieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.darkIcon,

        body:  Center(
          child: Column(
            children: [
              Center(child: Image.asset("assets/images/bookingSearvice2.png")),
              SizedBox(height: 30,),
              Text("Booking Generated Successfully",style: TextStyle(fontSize: 18,color: colors.primary,),),
              Text("Your order will be delivered tomorrow",style: TextStyle(fontSize: 20,color: colors.primary,),),
              SizedBox(height: 50,),
              Container(
                color: colors.darkIcon,
                width: MediaQuery.of(context).size.width/1.2,
                child: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));

                  },
                  child:  Padding(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                     color:colors.whiteTemp,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset("assets/images/correct.png",height: 50,),
                            SizedBox(width: 15,),
                            Text("Booking Confirmed!",style: TextStyle(fontSize: 20,color: colors.primary,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
