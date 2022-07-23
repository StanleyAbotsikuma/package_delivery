import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:packagedelivery/Provider/packageDetails_provider.dart';
import 'package:packagedelivery/models.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:packagedelivery/utility/route.dart';
import 'package:packagedelivery/utility/theme.dart';
import 'package:provider/provider.dart';

import 'Provider/receiverDetails_provider.dart';
import 'Provider/senderDetails_provider.dart';

void main() {
  runApp(PackageDelivery());

}

class PackageDelivery extends StatefulWidget {
  @override
  _PackageDeliveryState createState() => _PackageDeliveryState();
}

class _PackageDeliveryState extends State<PackageDelivery> {
  @override
  void initState() {
    super.initState();
    var myDeviceInfo = DeviceInfo();
    myDeviceInfo.androidId();
    // configureOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SenderDetailsProvider>(create: (context) => SenderDetailsProvider()),
        ChangeNotifierProvider<ReceiverDetailsProvider>(create: (context) => ReceiverDetailsProvider()),
        ChangeNotifierProvider<PackageDetailsProvider>(create: (context) => PackageDetailsProvider()),
      ],
      child: MaterialApp(
        title: 'Delivery Package Application',
        theme: ThemeData(appBarTheme: appBarTheme(), fontFamily: 'Raleway'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  // Future<void> configureOneSignal() async{
  //   await OneSignal.shared.init('150f5740-6ad6-4227-8355-0741932c3ace');
  //   await OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  //   await OneSignal.shared.setNotificationReceivedHandler((notification) {
  //     print(notification.payload);
  //   });
   
  // }
}
