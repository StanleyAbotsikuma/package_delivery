import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'dart:convert';
import 'dart:async';

class testPage extends StatefulWidget {
  @override
  _testPageState createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  List<dynamic> newLoad = [];
  var cron = new Cron();
  Timer timer;
  @override
  void initState() {
    super.initState();
    // cron.schedule(new Schedule(seconds: 1), () async {
      // load();
    // });
     timer = Timer.periodic(Duration(seconds: 2), (Timer t) =>  load());
  }

  @override
  void dispose() {
     timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextPage"),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: FlatButton(
                color: Colors.amber,
                child: Text("Click Check"),
                onPressed: () => check(),
              ),
            ),
            Center(
              child: FlatButton(
                color: Colors.cyan,
                child: Text("Click to Load"),
                onPressed: () => load(),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                       itemCount: newLoad.length,
                          itemBuilder: (context, index) {
                         if (newLoad.length != 0) {
                           return Padding(
                              padding: EdgeInsets.all(10),
                          child: Container(
                              child: Text(
                                newLoad[index].toString(),
                              ),
                              color: Colors.amber));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  load() {
    if (newLoad.length != 0) {
      newLoad.clear();
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
        //print(d["RESULT"]);
if( d["RESULT"]!=null)
   {     setState(() {
          d["RESULT"].forEach((v) => newLoad.add(v));
        });

       }    // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", data);
  }

  check() async {
    Map data = {
      "METHOD": "ADDREQUEST",
      "APIKEY": "2c75bf-4eb91a-918864-9cd7a0-0de148",
      "USERNAME": "MadreK Delivery",
      "PASSWORD": "tyma123456789",
      "PROVIDERID": "1001",
      "REQUESTID": "1155555555555552121121211212555555555555555555555",
      "FIRSTNAME": "jane",
      "SURNAME": "udema",
      "EMAIL": "pabasa33@gmail.com",
      "CONTACT": "05470945221",
      "LAT": "0.098767",
      "LONG": "0.120987",
      "LOCATION": "Ashongman Estate",
      "DEVICEID": DeviceInfo().androidInfoId,
      "RECEIVER_SURNAME": "KWAME",
      "RECEIVER_OTHERNAME": "TYMA",
      "RECEIVER_CONTACT": "0547094522",
      "RECEIVER_LAT": "0.0093",
      "RECEIVER_LONG": "-0.4334",
      "RECEIVER_ADDRESS": "HAATSO",
      "PACKAGEID": "44444444444444444444444444444",
      "PRICE": "20",
      "ITEM": "SOFoddO",
      "WEIGHT": "120KG",
      "CATEGORY": "FOOD",
      "COMMENT": "Thbnmnbmnbmns the comment",
      "STATUS": "Pending",
      "COURIER": "1",
      "PAYMENTMODE": "cash",
      "COLLECTIONPOINT": "sender"
    };

    Dio dio = new Dio();

    void postHTTP(String url, Map data) async {
      try {
        final response = await dio.post(url, data: data);
        //print(response);
        final Map<String, dynamic> d = json.decode(response.data.toString());
        print(d);
        // Do whatever
      } on DioError catch (e) {
        // Do whatever
      }
    }

    postHTTP("https://api.buymoreghana.com/backend/api/index.php", data);
  }
}
