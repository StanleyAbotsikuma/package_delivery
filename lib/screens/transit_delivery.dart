import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/deviceInfo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:expandable/expandable.dart';
import 'package:packagedelivery/models.dart';
import 'package:packagedelivery/screens/tracking_package_details.dart';

class Intransit extends StatefulWidget {
  @override
  _IntransitState createState() => _IntransitState();
}

class _IntransitState extends State<Intransit> {
  String id;
  bool initFailed;
  String status  = 'Transit';
  QueryBuilder<ParseObject> _queryBuilder;
  @override
  void initState() {
    super.initState();
    var myDeviceInfo = DeviceInfo();
    id = myDeviceInfo.androidInfoId;

    initData().then((bool success) {
      setState(() {
        initFailed = !success;
        if (success)
          _queryBuilder = QueryBuilder<ParseObject>(ParseObject('request'))
            ..whereEqualTo("user_id", "${id}")
            ..whereEqualTo("status", "${status}");
      });
    }).catchError((dynamic _) {
      setState(() {
        initFailed = true;
      });
    });
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
                          SizedBox(height:9.0),
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
          child: ParseLiveListWidget<ParseObject>(
              query: _queryBuilder,
              duration: const Duration(seconds: 1),
              childBuilder: (BuildContext context,
                  ParseLiveListElementSnapshot<ParseObject> snapshot)  {
                if (snapshot.failed) {
                  return const Text('something went wrong!');
                } else if (snapshot.hasData) {
         
                        return  ExpandablePanel(
      header: GestureDetector(
                    onLongPress:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => tracking_package_detail("${status}","${(snapshot.loadedData).get('request_id')}","${(snapshot.loadedData).get('item')}","${(snapshot.loadedData).get('packageID')}","${(snapshot.loadedData).get('riderId')}")),);
                    },
                    child:Container(
                    child:ListTile(
                       leading: Container(width: 50.0,height: 50.0,child: Center( child:Image.asset(ImageAsset.parcel,),),decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(100)),),
                      title: Row(children:[Expanded(flex:2,child:Text("${(snapshot.loadedData).get('item')}")),Expanded(flex:1,child:Text("#${(snapshot.loadedData).get('packageID')}",style: TextStyle(
                
                fontWeight: FontWeight.w900,
                fontSize: 15.0)))]),
                      subtitle: Text(DateFormat("E, d MMMM, H:m:s")
                          .format(snapshot.loadedData.updatedAt))
                          ),
                  ),
                  ),
     
      expanded:              Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        elevation: 2,
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: columnText("Rider's Name",
                                                  '${(snapshot.loadedData).get('riderfullname')}', true),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: columnText(
                                                  "Rider's Number Plate",
                                                  '${(snapshot.loadedData).get('riderId')}',
                                                  true),
                                            ))
                                      ]),
                                
                                                                  ]))))
                  ,
      tapHeaderToExpand: true,
      hasIcon: true,
    );  } else {
                  return const ListTile(
                    leading: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
}
  Widget columnText(String title, String value, bool bold_id) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${title}:',
            style: TextStyle(
                color: Color(0xFFffc95a),
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
                color: Color(0xFFffc95a),
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


  Future<bool> initData() async {
    await Parse().initialize(keyParseApplicationId, keyParseServerUrl,
        clientKey: keyParseClientKey,
        debug: keyDebug,
        liveQueryUrl: keyParseLiveServerUrl);

    return (await Parse().healthCheck()).success;
  }
}

    // for (var json in courier.results) {
    //   toJson = RiderData.fromJson(json);
    // }

    // print("${toJson.riderOthername} d jgjhjgjjhgjh");

    // var queryString =
    //     'where={"user_id": "${id}","request_id":"BXs-668-Mwh-017"}';
    // var courier = await ParseObject('request').query(queryString);

    // var toJson;
    // for (var json in courier.results) {
    //   toJson = Request.fromJson(json);
    // }

    // print("${toJson.requestId} d jgjhjgjjhgjh");