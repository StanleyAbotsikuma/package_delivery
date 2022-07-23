import 'dart:convert';
import 'package:cron/cron.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:packagedelivery/screens/tracking_package_details.dart';
import 'package:expandable/expandable.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class PendingDelivery extends StatefulWidget {
  @override
  _PendingDeliveryState createState() => _PendingDeliveryState();
}

class _PendingDeliveryState extends State<PendingDelivery> {
  String id;
  bool initFailed = false;
  Timer timer;
  List<dynamic> loadData = [];
  var cron = new Cron();
  @override
  void initState() {
    super.initState();
    var myDeviceInfo = DeviceInfo();
    id = myDeviceInfo.androidInfoId;
    // load();
    timer = Timer.periodic(Duration(seconds: 5), (_) => load());
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
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
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFF8F8F8), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: loadData.length,
                  itemBuilder: (context, index) {
                    if (loadData.length != 0) {
                      if (loadData[index]['status'] == "Pending") {
                        return pending(loadData[index]);
                      } else if (loadData[index]['status'] == "Assigned") {
                        return assigned(loadData[index]);
                      } else if (loadData[index]['status'] == "Transit") {
                        return transit(loadData[index]);
                      }

                      // if (snapshot.failed) {
                      // return const Text('something went wrong!');
                      // } else if (snapshot.hasData) {
                      // if (snapshot["status"] == "Pending") {
                      // return pending(snapshot);
                      // }
                      // else if (snapshot["status"] == "Assigned") {
                      //  return assigned(snapshot);
                      // }
                      //  else if (snapshot["status"] == "Transit") {
                      //  return transit(snapshot);
                      // }
                      //
                      // } else {
                      // return const ListTile(
                      // leading: CircularProgressIndicator(),
                      // );
                      // }
                    } else {}
                  }),
            ),
          ],
        ));
  }

//
  // Future<bool> initData() async {
  // await Parse().initialize(keyParseApplicationId, keyParseServerUrl,
  // clientKey: keyParseClientKey,
  // debug: keyDebug,
  // liveQueryUrl: keyParseLiveServerUrl);
//
  // return (await Parse().healthCheck()).success;
  // }
//
//
//
  Widget pending(snapshot) {
    int current_step = 0;
    List<Step> steps = [
      Step(
        title: Text('Pending',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.0)),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package waiting to be assigned'),
              Text(snapshot["dateTimeCreated"])
            ]),
        isActive: true,
      ),
      Step(
        title: Text('Assigned'),
        content: Text('Package waiting for pick-up'),
        isActive: false,
      ),
      Step(
        title: Text('In Transit'),
        content: Text('Package is been delivered'),
        isActive: false,
      ),
    ];
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFDFDFD), Color(0xFFF9FFFF)],
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBEBEBE),
              blurRadius: 10.0,
              spreadRadius: 0.4,
              offset: Offset(1.0, 5.0),
            ),
          ],
        ),
        child: ExpandablePanel(
          header: ListTile(
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
                              fontWeight: FontWeight.w900, fontSize: 15.0))
                    ]))
              ]),
              subtitle: Text(snapshot["packageID"],
                  style: TextStyle(fontSize: 11.0))),
          expanded: Container(
            child: Column(children: [
              Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
                currentStep: current_step,
                steps: steps,
                type: StepperType.vertical,
              ),
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tracking_package_detail(
                                  snapshot["status"],
                                  snapshot["requestID"],
                                  snapshot["item"],
                                  snapshot["packageID"])),
                        );
                      },
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ]))
            ]),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
        ));
  }

//
//
//
//
  Widget assigned(snapshot) {
    int current_step = 1;
    List<Step> steps = [
      Step(
        title: Text('Pending'),
        content: Column(children: [
          Text('Package waiting to be assigned'),
          Text(snapshot["dateTimeCreated"])
        ]),
        isActive: false,
      ),
      Step(
        title: Text('Assigned',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.0)),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package waiting for pick-up'),
              Text(snapshot["dateTimeCreated"])
            ]),
        isActive: true,
      ),
      Step(
        title: Text('In Transit'),
        content: Text('Package is been delivered'),
        isActive: false,
      ),
    ];
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFDFDFD), Color(0xFFF9FFFF)],
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBEBEBE),
              blurRadius: 10.0,
              spreadRadius: 0.4,
              offset: Offset(1.0, 5.0),
            ),
          ],
        ),
        child: ExpandablePanel(
          header: ListTile(
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
                              fontWeight: FontWeight.w900, fontSize: 15.0))
                    ]))
              ]),
              subtitle: Text(snapshot["packageID"],
                  style: TextStyle(fontSize: 11.0))),
          expanded: Container(
            child: Column(children: [
              Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
                currentStep: current_step,
                steps: steps,
                type: StepperType.vertical,
              ),
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tracking_package_detail(
                                  snapshot["status"],
                                  snapshot["requestID"],
                                  snapshot["item"],
                                  snapshot["packageID"],
                                  snapshot["riderID"])),
                        );
                      },
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ]))
            ]),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
        ));
  }

  Widget transit(snapshot) {
    int current_step = 2;
    List<Step> steps = [
      Step(
        title: Text('Pending'),
        content: Column(children: [
          Text('Package waiting to be assigned'),
          Text(snapshot["dateTimeCreated"])
        ]),
        isActive: false,
      ),
      Step(
        title: Text('Assigned'),
        content: Column(children: [
          Text('Package waiting to be assigned'),
          Expanded(flex: 1, child: Container()),
          Text(snapshot["dateTimeCreated"])
        ]),
        isActive: false,
      ),
      Step(
        title: Text('In Transit',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.0)),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package is been delivered'),
              Expanded(flex: 1, child: Container()),
              Text(snapshot["dateTimeCreated"])
            ]),
        isActive: true,
      ),
    ];
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFDFDFD), Color(0xFFF9FFFF)],
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBEBEBE),
              blurRadius: 10.0,
              spreadRadius: 0.4,
              offset: Offset(1.0, 5.0),
            ),
          ],
        ),
        child: ExpandablePanel(
          header: ListTile(
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
                              fontWeight: FontWeight.w900, fontSize: 15.0))
                    ]))
              ]),
              subtitle: Text(snapshot["packageID"],
                  style: TextStyle(fontSize: 11.0))),
          expanded: Container(
            child: Column(children: [
              Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
                currentStep: current_step,
                steps: steps,
                type: StepperType.vertical,
              ),
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tracking_package_detail(
                                  snapshot["status"],
                                  snapshot["requestID"],
                                  snapshot["item"],
                                  snapshot["packageID"],
                                  snapshot["riderID"])),
                        );
                      },
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ]))
            ]),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
        ));
  }
//
//
//
  
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
              if (v["status"] != "Delivered") loadData.add(v);
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
