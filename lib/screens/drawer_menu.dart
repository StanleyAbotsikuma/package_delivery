import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packagedelivery/utility/constant.dart';

class DrawerMenu extends StatefulWidget {

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFDC830),Color(0xFFF37335)]),
              ),
              padding: EdgeInsets.all(0.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   FutureBuilder(
                     future: deviceInfo(),
                     builder: (BuildContext context, snapshot){
                       return CachedNetworkImage(imageUrl: 'https://api.adorable.io/avatars/100/${snapshot.data}.png');
                     },

                   ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Guest',
                            style:
                            TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(
                FontAwesomeIcons.home,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: Text('Send Package'),
              leading: Icon(
                FontAwesomeIcons.truckMoving,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/sendpackage');
              }
            ),
            /*
            ListTile(
              title: Text('Receive Package'),
              leading: Icon(
                FontAwesomeIcons.truckLoading,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            */
            ListTile(
              title: Text('Track Package'),
              leading: Icon(
                FontAwesomeIcons.history,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            /*
            ListTile(
              title: Text('Account'),
              leading: Icon(
                FontAwesomeIcons.userCircle,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            */
          ],
        ),
      ),
    );
  }




  Future<String> deviceInfo() async{
    var constant = Constant();
    return  await constant.setDeviceInfo();;
  }
}

