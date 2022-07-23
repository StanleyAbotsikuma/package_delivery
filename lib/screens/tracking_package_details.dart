import 'package:flutter/material.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:parse_server_sdk_flutter/generated/i18n.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:io';
import 'package:packagedelivery/models.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class tracking_package_detail extends StatefulWidget {
  String status;
  String detail_requestId;
  String detail_packageId;
  String detail_packageName;
  String ridersId;

  tracking_package_detail(this.status, this.detail_requestId,
      this.detail_packageName, this.detail_packageId,
      [this.ridersId]);

  @override
  _tracking_package_detailState createState() =>
      _tracking_package_detailState();
}

class _tracking_package_detailState extends State<tracking_package_detail> {
  String id;
  var packageResponse;
  var senderResponse;
  var receiverResponse;
  var riderResponse;
  bool initFailed = false;
  String tryImage;
  String packageName;
  String packageCategory;
  String packageID;
  String packageWeight;
  String packageDescription;
  String packagePrice;

  String pickup;

  String rNameFirst;
  String rNameLast;
  String deliveryPoint;

  String rContact;
  String rEmail;

  String tNameFirst;
  String tNameLast;
  String tLicense;

  String tContact;

  @override
  void initState() {
    super.initState();
    var myDeviceInfo = DeviceInfo();
    id = myDeviceInfo.androidInfoId;

    requestDataR();
    requestDataS();
    requestDataRi();
    requestDataI();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE0DFDD),
        ),
        body: mainBody(context));
  }

  Widget mainBody(BuildContext context) {
    return Column(children: [
      //Main column

      //intro image
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0),
        child: Row(
          children: <Widget>[
            Icon(
              LineIcons.cubes,
              size: 40.0,
            ),
            SizedBox(width: 5.0),
            Text(
              widget.detail_packageId,
              style: TextStyle(fontSize: 25.0),
            ),
          ],
        ),
      ),
      // second section .. Place for info
      Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SingleChildScrollView(
                child: initFailed == false
                    ? LoadContent(context)
                    : Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: initFailed == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(height: 15.0),
                                  Text('Loading...'),
                                ],
                              )
                            : const Text('Try Again'),
                      ),
              )))
    ]);
  }

  Widget LoadContent(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Color(0xFFe6e6e6),
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Package Info',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: columnText(
                                "Package Name", '${packageName}', false),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: columnText("Package Catergory",
                                '${packageCategory}', false),
                          ))
                    ])),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child:
                              columnText("Package ID", '${packageID}', false),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: columnText(
                              "Delivery Fee", 'Ghs ${packagePrice}', false),
                        ))
                  ]),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: columnText(
                    "Package Description", '${packageDescription}', false)),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Color(0xFFe6e6e6),
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'To',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    LineIcons.user,
                    color: Color(0xFF999999),
                  ),
                  SizedBox(width: 5.0),
                  Text('${rNameFirst} ${rNameLast}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        LineIcons.mobile,
                        color: Color(0xFF999999),
                      ),
                      SizedBox(width: 5.0),
                      Text('${rContact}'),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      LineIcons.phone,
                      size: 25.0,
                      color: Color(0xFFF19827),
                    ),
                    onPressed: () {
                      launchCall(phone: '${rContact}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Destination',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    LineIcons.street_view,
                    color: Color(0xFF999999),
                  ),
                  SizedBox(width: 10.0),
                  Flexible(child: Text("${pickup}")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    LineIcons.ellipsis_v,
                    color: Color(0xFF999999),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        LineIcons.map_o,
                        color: Color(0xFF999999),
                      ),
                      SizedBox(width: 10.0),
                      Text('${deliveryPoint}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      (() {
        if (widget.status == 'Pending') {
          return pending(context);
        } else if (widget.status == 'Assigned') {
          return Column(children: [
            assigned(context),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                elevation: 2,
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: columnText("Rider's Name",
                                          '${tNameFirst} ${tNameLast}', true),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: columnText("Rider's Number Plate",
                                          '${tLicense}', true),
                                    ))
                              ]),
                          SizedBox(height: 15.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: columnText("Rider's Contact",
                                          "${tContact}", true),
                                    )),
                              ]),
                          SizedBox(height: 15.0),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: tryImage == null
                                      ? NetworkImage('${tryImage}')
                                      : NetworkImage('${tryImage}'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ]))))
          ]);
        } else if (widget.status == 'Transit') {
          return Column(children: [
            transit(context),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                elevation: 2,
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: columnText("Rider's Name",
                                          '${tNameFirst} ${tNameLast}', true),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: columnText("Rider's Number Plate",
                                          '${tLicense}', true),
                                    ))
                              ]),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    LineIcons.mobile,
                                    color: Color(0xFF999999),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text('${tContact}'),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  LineIcons.phone,
                                  size: 25.0,
                                  color: Color(0xFFF19827),
                                ),
                                onPressed: () {
                                  launchCall(phone: '${tContact}');
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage('${tryImage}'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ]))))
          ]);
        } else {
          return completed(context);
        }
      }())
    ]);
  }

  Widget columnText(String title, String value, bool bold_id) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${title}:',
            style: TextStyle(
                color: Colors.grey,
                // decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                fontSize: 15.0)),
        SizedBox(height: 5.0),
        Text(value,
            style: TextStyle(
                fontWeight:
                    bold_id == true ? FontWeight.w800 : FontWeight.normal,
                fontSize: 15.0))
      ],
    ));
  }

  Widget rowText(String title, String value, bool bold_id) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${title}:',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 15.0)),
        SizedBox(width: 5.0),
        Text(value,
            style: TextStyle(
                fontWeight:
                    bold_id == true ? FontWeight.w800 : FontWeight.normal,
                fontSize: 15.0))
      ],
    ));
  }

  Widget completed(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status:',
              style: TextStyle(
                  color: Color(0xFFffc95a),
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0)),
          SizedBox(width: 5.0),
          Text("Completed...",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  color: Colors.green))
        ],
      ),
    );
  }

  Widget pending(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status:',
              style: TextStyle(
                  color: Color(0xFFffc95a),
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0)),
          SizedBox(width: 5.0),
          Text("Pending...",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  color: Colors.blue))
        ],
      ),
    );
  }

  Widget assigned(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status:',
              style: TextStyle(
                  color: Color(0xFFffc95a),
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0)),
          SizedBox(width: 5.0),
          Text("Assigned - Waiting for Pick-Up...",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  color: Color(0xFFF15AFF)))
        ],
      ),
    );
  }

  Widget transit(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status:',
              style: TextStyle(
                  color: Color(0xFFffc95a),
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0)),
          SizedBox(width: 5.0),
          Text("In Transit...",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  color: Color(0xFF970348)))
        ],
      ),
    );
  }
//

//

  requestDataI() async {
    var query = {
      "METHOD": "GETPACKAGEREQUEST",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "REQUESTID": widget.detail_requestId
    };

    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        //print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            print(d["RESULT"][0]);

            //
            packageName = d["RESULT"][0]["item"].toString();
            packageCategory = d["RESULT"][0]["category"];
            packageID = widget.detail_packageId;
            packageWeight =d["RESULT"][0]["weight"];
            if (d["RESULT"][0]["comment"].trim() == "") {
              packageDescription = "n/a";
            } else {
              packageDescription = d["RESULT"][0]["comment"];
            }
            packagePrice = d["RESULT"][0]["price"];
          });
        } // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", query);
  }

  requestDataR() async {
    var query = {
      "METHOD": "GETRECEIVERREQUEST",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "REQUESTID": widget.detail_requestId
    };

    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        //print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            print(d["RESULT"][0]);

            rNameFirst = d["RESULT"][0]["firstname"];
            rNameLast = d["RESULT"][0]["surname"];
            deliveryPoint = d["RESULT"][0]["location"];
            rContact = d["RESULT"][0]["contact"];
            if (d["RESULT"][0]["email"].trim() == "") {
              rEmail = "n/a";
            } else {
              rEmail = d["RESULT"][0]["email"];
            }
          });
        } // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", query);
  }

  requestDataRi() async {
    var query = {
    "METHOD": "GETRIDERBYID",
    "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
    "USERNAME": "MadreK Delivery",
    "PASSWORD": "tyma123456789",
    "PROVIDERID": "1001",
    "RIDERID":widget.ridersId
};

    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        //print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            print(d["RESULT"][0]);

            tNameFirst = d["RESULT"][0]["othername"];
            tNameLast = d["RESULT"][0]["surname"];
            tLicense = d["RESULT"][0]["motor_number"];

            tContact = d["RESULT"][0]["tel"];
          });
        } // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", query);
  }

  requestDataS() async {
    var query = {
      "METHOD": "GETSENDERREQUEST",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "REQUESTID": widget.detail_requestId
    };

    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        //print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            print(d["RESULT"][0]);
            pickup = d["RESULT"][0]["location"];
          });
        } // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", query);
  }

  requestData() async {
    var query = {
      "METHOD": "GETSENDERREQUEST",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "REQUESTID": widget.detail_requestId
    };
    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        //print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            print(d["RESULT"][0]);
            // tNameFirst = loader.riderOthername;
            // tNameLast = loader.riderSurname;
            // tLicense = loader.riderLicense;
            // pickup = loader.location;
            // tContact = loader.riderTel;
            // packageName = loader.item;
            // packageCategory = loader.category;
            // packageID = widget.detail_packageId;
            // packageWeight = loader.weight;
            // if (loader.comment.trim() == "") {
            // packageDescription = "n/a";
            // } else {
            // packageDescription = loader.comment;
            // }
            // packagePrice = loader.price;
            // rNameFirst = loader.firstname;
            // rNameLast = loader.surname;
            // deliveryPoint = loader.location;
            // rContact = loader.contact;
            // if (loader.email.trim() == "") {
            // rEmail = "n/a";
            // } else {
            // rEmail = loader.email;
            // }
          });
        } // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", query);
  }

  imageFunc() async {
    var loader;
    var queryString = 'where={"Id": "${widget.ridersId}" }';
    var q = await ParseObject('Images').query(queryString);
    for (var json in q.results) {
      loader = ImageGet.fromJson(json);
    }
    ParseFile image = loader.imageFile;
    setState(() {
      //Map<String, dynamic> loadImage = jsonDecode(image.toString());
      tryImage = image.url;
    });
  }

  void launchCall({
    @required String phone,
    //@required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "tel:$phone";
      } else {
        return "tel:$phone";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
      print(url());
    } else {
      print(url());
//      throw 'Could not launch ${url()}';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
              content: Text('Could not launch call app'),
            );
          });
    }
  }
}

// // first section >>>> package information
//             Container(
//               margin: const EdgeInsets.only(
//                   top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //content for information

// Row(

//children: [
//       Expanded(
//           flex: 1,
//           child: Container(
//             alignment: Alignment.centerLeft,
//             width: MediaQuery.of(context).size.width * 0.25,
//             child: columnText("Package Name",
//                 '${packageName}', false),
//           )),
//       Expanded(
//           flex: 1,
//           child: Container(
//             alignment: Alignment.centerLeft,
//             width: MediaQuery.of(context).size.width * 0.25,
//             child: columnText(
//                 "Package Catergory", '${packageCategory}', false),
//           ))
//     ]),
// SizedBox(height: 15.0),
// Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Expanded(
//           flex: 1,
//           child: Container(
//             alignment: Alignment.centerLeft,
//             width: MediaQuery.of(context).size.width * 0.25,
//             child:
//                 columnText("Package ID", '#${packageID}', true),
//           )),
//       Expanded(
//           flex: 1,
//           child: Container(
//             alignment: Alignment.centerLeft,
//             width: MediaQuery.of(context).size.width * 0.25,
//             child:
//                 columnText("Package Weight", '${packageWeight}', false),
//           ))
//     ]),
// SizedBox(height: 15.0),
// columnText(
//     "Package Description",
//     '${packageDescription}',
//     false),
//                   SizedBox(height: 15.0),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                             flex: 1,
//                             child: Container(
//                               alignment: Alignment.centerLeft,
//                               width: MediaQuery.of(context).size.width * 0.25,
//                               child: columnText("Pick-Up Point",
//                                   '${pickup}', true),
//                             )),
//                         Expanded(
//                             flex: 1,
//                             child: Container(
//                               alignment: Alignment.centerLeft,
//                               width: MediaQuery.of(context).size.width * 0.25,
//                               child: columnText(
//                                   "Calculated Price", 'GHC ${packagePrice}', true),
//                             ))
//                       ])
//                 ],
//               ),
//             ),

//             //Second section >>>>>>>>>>>>>>>>>>>>>> receivers section
//             Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                 elevation: 2,
//                 child: Padding(
//                     padding: const EdgeInsets.all(18.0),
//                     child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           alignment: Alignment.centerLeft,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.25,
//                                           child: columnText(
//                                               "Receiver's Full Name",
//                                               "${rNameFirst} ${rNameLast}",
//                                               true),
//                                         )),
//                                     Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           alignment: Alignment.centerLeft,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.25,
//                                           child: columnText(
//                                               "Delivery Point",
//                                               '${deliveryPoint}',
//                                               true),
//                                         ))
//                                   ]),
//                               SizedBox(height: 15.0),
//                               columnText(
//                                   "Receiver's Contact", '${rContact}', true),
//                               SizedBox(height: 15.0),
//                               columnText("Receiver's E-mail", '${rEmail}', false),
//                               SizedBox(height: 15.0),
//                             ])))),
//             SizedBox(height: 15.0),
