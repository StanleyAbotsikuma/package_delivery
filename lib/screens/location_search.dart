import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class LocationSearch extends StatefulWidget {
  //String searchText;
 // LocationSearch({this.searchText});
  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  String searchText;
  List<ListTile> searchedLocation;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Search Location',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(icon: Icon(FontAwesomeIcons.search, size: 15.0)),
            textInputAction: TextInputAction.search,
            onSubmitted: (value){
              setState(() {
                searchText = value;
              });
            },

          ),
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: getLocation(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Container(child: Center(child: CircularProgressIndicator()));
                  case ConnectionState.done:
                    if(snapshot.hasData){
                      return ListView.separated(
                          itemBuilder: (context,index){
                            return searchedLocation[index];
                          },
                          separatorBuilder: (context,index){
                            return Divider();
                          },
                          itemCount: searchedLocation.length
                      );
                    }else{
                      return Container(child: Center(child: Text('No location'),),);
                    }
                }
                return Container(child: Center(child: Text('No location'),),);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<ListTile>> getLocation() async{
    if(searchText.isEmpty || searchText == null){
      return searchedLocation;
    }

    List<ListTile> _list  = [];
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/queryautocomplete/json';
    String apiKey = Constant.APIKEY;
    String location = Constant.LOCATION;
    String request = '$baseUrl?input=$searchText&key=$apiKey';
    Response response = await Dio().get(request);


    for(int i = 0; i < response.data['predictions'].length; i++){
      final predictions = response.data['predictions'][i]['description'];
      final id = response.data['predictions'][i]['place_id'];
      final place = Places(predictions,id);
      _list.add(ListTile(title: Text(place.name),onTap: (){Navigator.pop(context, place);},));
    }

    searchedLocation = _list;
    return searchedLocation;
  }

  getLatLong(String id) async{
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    String apiKey = Constant.APIKEY;
    String request = '$baseUrl?place_id=$id&key=$apiKey';
    Response response = await Dio().get(request);
    var location = Location(response.data['result']['geometry']['location']['lat'], response.data['result']['geometry']['location']['lng']);
    return response.data['result']['geometry']['location'];
  }
}
