import 'package:flutter/material.dart';
import 'package:packagedelivery/models.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TransportType extends StatefulWidget {
  @override
  _TransportTypeState createState() => _TransportTypeState();
}

class _TransportTypeState extends State<TransportType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: Text(
          'Courier Type',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFffc95a),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(itemBuilder: (context,index){
              return  ListTile(title: Text(snapshot.data[index].name));
            }, separatorBuilder: (context,index) => Divider(), itemCount: snapshot.data.length);
          }else{
            return Center(child: CircularProgressIndicator());
          }

        },
      )
    );
  }

  Future<List<Courier>> getData() async {
    await Parse().initialize(Constant.APP_ID, Constant.SERVER_URL,
        appName: Constant.APP_NAME,
        clientKey: Constant.CLIENT_KEY);

    var queryString = 'where={"status": "active"}';
    var courier = await ParseObject('vehicleType').query(queryString);

    var courierList = List<Courier>();

    for(var json in courier.results){
      courierList.add(Courier.fromJson(json));
    }

    return courierList;


  }
}
