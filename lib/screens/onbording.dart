import 'package:flutter/material.dart';
import 'package:packagedelivery/screens/home.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardingScreen extends StatelessWidget {
  Widget screen;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firstTime(),
      builder: (context,snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.none:
          case ConnectionState.active:
            screen = scaffold(context);
            return screen;
          case ConnectionState.done:
            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
              if(snapshot.data == true){
                screen = Home();
              }else{
                screen  = scaffold(context);
              }
            }
        }
        return screen;

      },
    );
  }

Widget scaffold(context){
    return Scaffold(
      body: SKOnboardingScreen(
        pages: pages,
        bgColor: Colors.white,
        themeColor: Colors.black87,
          skipClicked: (value){
           Navigator.pushNamed(context, '/home');
        },
        getStartedClicked: (value){
          setVisit();
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
}

Future<bool> firstTime() async{
  final shared = await SharedPreferences.getInstance();
  bool status = shared.getBool('visited') ?? false;
  return status;
}

setVisit() async{
  final shared = await SharedPreferences.getInstance();
  shared.setBool('visited',true);
}



  final pages = [
    SkOnboardingModel(
        title: 'Home Delivery',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: ImageAsset.delivery
    ),
    SkOnboardingModel(
        title: 'Nationwide Delivery',
        description:
        'We make ordering fast, simple and free-no matter if you order online or cash',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: ImageAsset.delivery_anywhere
    ),
    SkOnboardingModel(
        title: 'Delivery Order',
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: ImageAsset.send_package
    ),
  ];



}
