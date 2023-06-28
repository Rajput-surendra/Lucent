import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Color.dart';
import '../Screen/Bottom.dart';

class PlanSuccessScreen extends StatefulWidget {
  const PlanSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PlanSuccessScreen> createState() => _PlanSuccessScreenState();
}

class _PlanSuccessScreenState extends State<PlanSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.darkIcon,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Center(child: Image.asset("assets/subcrption.png",scale: 1.2,)),
              SizedBox(height: 30,),
              Text("Congrats! You saved approx 2100-2500\n Ltr.(Monthly) Water by\n Choosing Waterless Cleaning",
              style: TextStyle(fontSize: 20,color: colors.primary,),),
              //Text("Your order will be delivered tomorrow",style: TextStyle(fontSize: 20,color: colors.primary,),),
              SizedBox(height: 30,),
              Container(
                color: colors.darkIcon,
                width: MediaQuery.of(context).size.width/1.5,
                child: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
                    // Fluttertoast.showToast(
                    //     msg: "Enquire Generate Successfully",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.BOTTOM,
                    //     timeInSecForIosWeb: 5,
                    //     backgroundColor: colors.primary,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.primary
                      ),
                      child: Center(child: Text("Back to home",style: TextStyle(color: colors.whiteTemp),)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
