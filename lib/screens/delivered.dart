import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:packagedelivery/screens/tracking_package_details.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class Delivered extends StatefulWidget {
  @override
  _DeliveredState createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  String id;
  String status = "Delivered";

  bool initFailed = false;

  List<dynamic> loadData = [];
  QueryBuilder<ParseObject> _queryBuilder;
  @override
  void initState() {
    super.initState();
    var myDeviceInfo = DeviceInfo();
    id = myDeviceInfo.androidInfoId;
    load();
  }

  @override
  Widget build(BuildContext context) {
    return initFailed == false
        ? buildBody(context)
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
          );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: loadData.length,
              itemBuilder: (context, index) {
                if (loadData.length != 0) {
                  final snapshot = loadData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tracking_package_detail(
                                  snapshot["status"],
                                  snapshot["requestID"],
                                  snapshot["item"],
                                  snapshot["packageID"],
                                  snapshot["riderID"])));
                    },
                    child: Container(
                      child: ListTile(
                          leading: Container(
                            width: 50.0,
                            height: 50.0,
                            child: Center(
                              child: Image.asset(
                                ImageAsset.parcel,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          title: Row(children: [
                            Expanded(child: Text(snapshot["item"])),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                  Text(snapshot["status"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15.0))
                                ]))
                          ]),
                          subtitle: Text(snapshot["packageID"],
                              style: TextStyle(fontSize: 11.0))),
                    ),
                  );
                } else {}
              }),
        ),
      ],
    );
  }

  load() {
    if (loadData.length != 0) {
      loadData.clear();
    }
    Map data = {
      "METHOD": "GETREQUESTBYDEVICEID",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "DEVICEID": DeviceInfo().androidInfoId,
    };
    Dio dio = new Dio();
    void postHTTP(String url, Map data) async {
      try {
        Response response = await dio.post(url, data: data);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        print(d["RESULT"]);
        if (d["RESULT"] != null) {
          setState(() {
            d["RESULT"].forEach((v) {
              if (v["status"] == status) loadData.add(v);
            });
          });
        }
        // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", data);
  }
}
