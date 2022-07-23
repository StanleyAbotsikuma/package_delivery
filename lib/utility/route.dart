import 'package:flutter/material.dart';
import 'package:packagedelivery/screens/categoryList.dart';
import 'package:packagedelivery/screens/history.dart';
import 'package:packagedelivery/screens/home.dart';
import 'package:packagedelivery/screens/image_picker.dart';
import 'package:packagedelivery/screens/onbording.dart';
import 'package:packagedelivery/screens/package_details.dart';
import 'package:packagedelivery/screens/payment_option.dart';
import 'package:packagedelivery/screens/reciever_details.dart';
import 'package:packagedelivery/screens/sendPackage.dart';
import 'package:packagedelivery/screens/sendPackageList.dart';
import 'package:packagedelivery/screens/sender_details.dart';
import 'package:packagedelivery/screens/summery.dart';
import 'package:packagedelivery/screens/transport_type.dart';

import 'package:packagedelivery/screens/testpage.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (BuildContext context) {
          return BoardingScreen();//testPage();
        });
        case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/sendpackage':
        return MaterialPageRoute(builder: (_) => SendPackage());
      case '/sendpackagelist':
        return MaterialPageRoute(builder: (_) => SendPackageList());
      case '/history':
        return MaterialPageRoute(builder: (_) => History());
      case '/summery':
        return MaterialPageRoute(builder: (_) => Summery());
      case '/sender_details':
        return MaterialPageRoute(builder: (_) => SenderDetails());
      case '/reciever_details':
        return MaterialPageRoute(builder: (_) => RecieverDetails());
      case '/package_details':
        return MaterialPageRoute(builder: (_) => PackageDetails());
      case '/imagePicker':
   return MaterialPageRoute(builder: (_) => ImagePickerScreen(arguments));
        
      case '/category':
        return MaterialPageRoute(builder: (_) => CategoryListView());
      case '/transport_type':
        return MaterialPageRoute(builder: (_) => TransportType());
      case '/payment_option':
        return MaterialPageRoute(builder: (_) => PaymentOption());
//      case '/paymentInfo':
//        return MaterialPageRoute(builder: (_) => PaymentInfo());
//      case '/orderList':
//        return MaterialPageRoute(builder: (_) => OrderList());
//      case '/store':
//        return MaterialPageRoute(builder: (_) => Store());
//      default:
      // MaterialPageRoute(builder:  (_) => BoardingScreen())
//        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
