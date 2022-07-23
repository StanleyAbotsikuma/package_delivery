import 'package:flutter/material.dart';
import 'package:min_id/min_id.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:packagedelivery/Provider/packageDetails_provider.dart';
import 'package:packagedelivery/Provider/receiverDetails_provider.dart';
import 'package:packagedelivery/Provider/senderDetails_provider.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class SendPackageList extends StatefulWidget {
  SendPackageList({Key key}) : super(key: key);

  @override
  _SendPackageListState createState() => _SendPackageListState();
}

class _SendPackageListState extends State<SendPackageList> {
  SenderDetailsProvider sender;
  ReceiverDetailsProvider receiver;
  PackageDetailsProvider package;
  bool showLoading = false;

  IconData senderIcon = Icons.arrow_forward_ios;
  Color senderIconColor = Colors.grey;

  IconData receiverIcon = Icons.arrow_forward_ios;
  Color receiverIconColor = Colors.grey;

  IconData packageIcon = Icons.arrow_forward_ios;
  Color packageIconColor = Colors.grey;

  String UniqueID(String w, String i) {
    var Li = i.split("");
    var Lw = w.split("");
    final _random = new Random();
    int x;
    List result = [];
    for (x = 1; x < 6; x++) {
      result.add(Li[_random.nextInt(Li.length)]);
      //print(x);
      if (x == 5) {
        result.add(Lw[_random.nextInt(Lw.length)]);
      }
    }

    return "${result.join()}";
  }

  var packageIDgen;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      packageIDgen =
          'PKG-${UniqueID("abcdefghijklmnopqrstuvwxyz".trim().toUpperCase(), "0123456789")}';
    });
//print(packageIDgen);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemList = [
      ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          child: Center(
            child: Text(
              'S',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.teal, borderRadius: BorderRadius.circular(100)),
        ),
        title: Text('Sender Information'),
        subtitle: Text('Eg. Name, Email, etc'),
        trailing: Consumer<SenderDetailsProvider>(
            builder: (context, senderModel, child) {
          sender = senderModel;
          if (senderModel.getStatus()) {
            senderIcon = Icons.done;
            senderIconColor = Colors.green;
          }
          return Icon(
            senderIcon,
            color: senderIconColor,
            size: 15.0,
          );
        }),
        onTap: () => Navigator.pushNamed(context, '/sender_details'),
      ),
      ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          child: Center(
            child: Text(
              'R',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(100)),
        ),
        title: Text('Reciever Information'),
        subtitle: Text('Eg. Name, Email, etc'),
        trailing:
            Consumer<ReceiverDetailsProvider>(builder: (context, model, child) {
          receiver = model;
          if (model.getStatus()) {
            receiverIcon = Icons.done;
            receiverIconColor = Colors.green;
          }
          return Icon(
            receiverIcon,
            color: receiverIconColor,
            size: 15.0,
          );
        }),
        onTap: () => Navigator.pushNamed(context, '/reciever_details'),
      ),
      ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          child: Center(
            child: Text(
              'P',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(100)),
        ),
        title: Text('Package Information'),
        subtitle: Text('Package name, weight, desc'),
        trailing: Consumer<PackageDetailsProvider>(
          builder: (context, model, child) {
            package = model;
            if (model.getStatus()) {
              packageIcon = Icons.done;
              packageIconColor = Colors.green;
            }
            return Icon(
              packageIcon,
              color: packageIconColor,
              size: 15.0,
            );
          },
        ),
        onTap: () => Navigator.pushNamed(context, '/package_details'),
      ),
      ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          child: Center(
            child: Text(
              'C',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(100)),
        ),
        title: Text('Courier Type'),
        subtitle: Text('Motor, Truck , Tricycle'),
        trailing: Consumer<PackageDetailsProvider>(
          builder: (context, model, child) {
            package = model;
            if (model.getStatus()) {
              packageIcon = Icons.done;
              packageIconColor = Colors.green;
            }
            return Icon(
              packageIcon,
              color: packageIconColor,
              size: 15.0,
            );
          },
        ),
        onTap: () => Navigator.pushNamed(context, '/transport_type'),
      ),
      ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          child: Center(
            child: Text(
              'P',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(100)),
        ),
        title: Text('Payment Option'),
        subtitle: Text('Payment type'),
        trailing: Consumer<PackageDetailsProvider>(
          builder: (context, model, child) {
            package = model;
            if (model.getStatus()) {
              packageIcon = Icons.done;
              packageIconColor = Colors.green;
            }
            return Icon(
              packageIcon,
              color: packageIconColor,
              size: 15.0,
            );
          },
        ),
        onTap: () => Navigator.pushNamed(context, '/payment_option'),
      ),

      // ListTile(
      //   leading: Icon(Icons.filter_none),
      //   title: Text('Summery'),
      //   subtitle: Text('Form preview'),
      //   trailing: Icon(
      //     Icons.arrow_forward_ios,
      //     size: 15.0,
      //   ),
      // )
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: Text(
          'Send Package',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFffc95a),
      ),
      body: Stack(
        children: [
          formList(itemList, context),
          showLoading ? loadingScreen() : Container()
        ],
      ),
    );
  }

  Widget loadingScreen() {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2f2822)),
        ),
      ),
      decoration: BoxDecoration(color: Colors.white12),
    );
  }

  Widget formList(List<ListTile> itemList, BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20.0),
              itemCount: itemList.length,
              separatorBuilder: (BuildContext context, index) {
                return Divider();
              },
              itemBuilder: (BuildContext context, index) {
                return itemList[index];
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60.0,
            child: InkWell(
              onTap: () async {
                setState(() {
                  showLoading = true;
                });
                if (!sender.getStatus()) {
                  setState(() {
                    senderIcon = Icons.error_outline;
                    senderIconColor = Colors.red;
                    showLoading = false;
                  });
                } else if (!receiver.getStatus()) {
                  setState(() {
                    receiverIcon = Icons.error_outline;
                    receiverIconColor = Colors.red;
                    showLoading = false;
                  });
                } else if (!package.getStatus()) {
                  setState(() {
                    packageIcon = Icons.error_outline;
                    packageIconColor = Colors.red;
                    showLoading = false;
                  });
                } else {
                  await Parse().initialize(Constant.APP_ID, Constant.SERVER_URL,
                      appName: Constant.APP_NAME,
                      clientKey: Constant.CLIENT_KEY,
                      debug: true);

                  var requestId = MinId.getId();

                  //             if(package.getImages().length != 0)
                  //             {

                  //         for (int i = 0; i < package.getImages().length; i++) {
                  //         var path = await FlutterAbsolutePath.getAbsolutePath(package.getImages()[i].identifier);

                  //            File tempFile = File(path);
                  //             ParseFile parseFile = ParseFile(tempFile, name: "image.jpg", debug: true);
                  //             var fileResponse = await parseFile.save();
                  //       if (fileResponse.success) {
                  //                 parseFile = fileResponse.result as ParseFile;
                  //             print(parseFile.toString());
                  //             print("Upload with success");
                  //               } else {
                  //              print("Upload with failed");
                  //           return;
                  //               }

                  //     var parseObject = ParseObject("Images", debug: true)
                  //  ..set<ParseFile>("imageFile", parseFile)
                  //  ..set("Id", requestId);
                  //       var apiResponse = await parseObject.save();

                  //               if (apiResponse.success) {
                  //                 print('ok');
                  //               } else {
                  //                 print("Error: " + apiResponse.error.toString());
                  //               }
                  //                               }
                  //             };

                  Map data = {
                    "METHOD": "ADDREQUEST",
                    "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
                    "USERNAME": "MadreK Delivery",
                    "PASSWORD": "tyma123456789",
                    "PROVIDERID": "1001",
//*********** */ sender
                    "REQUESTID": requestId,
                    "FIRSTNAME": sender.getFirstname(),
                    "SURNAME": sender.getSurname(),
                    "EMAIL": sender.getEmail(),
                    "CONTACT": sender.getContact(),
                    "LAT": sender.getLat(),
                    "LONG": sender.getLng(),
                    "LOCATION": sender.getLocation(),
                    "DEVICEID": DeviceInfo().androidInfoId,
//****************** */ receiver
                    "RECEIVER_SURNAME": receiver.getFirstname(),
                    "RECEIVER_OTHERNAME": sender.getSurname(),
                    "RECEIVER_CONTACT": receiver.getContact(),
                    "RECEIVER_LAT": receiver.getLat(),
                    "RECEIVER_LONG": receiver.getLng(),
                    "RECEIVER_ADDRESS": receiver.getLocation(),
//**************** */ package
                    "PACKAGEID": "$packageIDgen",
                    "PRICE": "20",
                    "ITEM": package.getItem(),
                    "WEIGHT": "120KG",
                    "CATEGORY": package.getCategory(),
                    "COMMENT": package.getComments(),
//***************** */ request
                    "STATUS": "Pending",
                    "COURIER": "1",
                    "PAYMENTMODE": "cash",
                    "COLLECTIONPOINT": "sender"
                  };

                  var alert = AlertDialog(
                    title: Text(
                      'Madrek Delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    elevation: 10,
                    content: Container(
                      child:
                          Text('A package request has successfuly been sent'),
                    ),
                    actions: [
                      FlatButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/'),
                      ),
                    ],
                  );

                  var alert1 = AlertDialog(
                    title: Text(
                      'Madrek Delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    elevation: 10,
                    content: Container(
                      child: Text(
                          'A package request has unsuccessfully, Please try again.'),
                    ),
                    actions: [
                      FlatButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                  Dio dio = new Dio();
                  void postHTTP(String url, Map data) async {
                    try {
                      final response = await dio.post(url, data: data);
                      //print(response);
                      setState(() {
                        showLoading = false;
                      });
                      final Map<String, dynamic> d =
                          json.decode(response.data.toString());
                      //{STATCODE: 200, STATMSG: Success}
                      if ((d["STATCODE"]).toString() == "200") {
                        if ((d["STATMSG"]).toString() == "Success") {
                          sender.unset();
                          receiver.unset();
                          package.unset();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => alert,
                            barrierDismissible: false,
                            barrierColor: Colors.white12,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => alert1,
                            barrierDismissible: false,
                            barrierColor: Colors.white12,
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => alert1,
                          barrierDismissible: false,
                          barrierColor: Colors.white12,
                        );
                      }
                      ;
                      // Do whatever
                    } on DioError catch (e) {
                      setState(() {
                        showLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => alert1,
                        barrierDismissible: false,
                        barrierColor: Colors.white12,
                      );
                      // Do whatever
                    }
                  }

                  postHTTP("https://api.buymoreghana.com/backend/api/index.php",
                      data);
                }
              },
              child: Container(
                color: Color(0xFF2f2822),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Send Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
