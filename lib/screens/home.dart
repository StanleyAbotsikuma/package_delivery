import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packagedelivery/screens/drawer_menu.dart';
import 'package:packagedelivery/utility/images.dart';
import 'package:packagedelivery/utility/size_config.dart';
import 'package:packagedelivery/utility/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:packagedelivery/Provider/senderDetails_provider.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
 
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   SenderDetailsProvider sender;
  String mlocation = 'Pick a loading';
  var screenHeight;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
@override
void initState() { 
  super.initState();
  
}
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
     return Consumer<SenderDetailsProvider>(
              builder: (context, senderModel, child) {
                senderModel.setup();
                return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.sort),
        //   onPressed: () {
        //     _scaffoldKey.currentState.openDrawer();
        //   },
        // ),
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.bell), onPressed: () {})
        ],
      ),
      //drawer: DrawerMenu(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'Deliver from anywhere to everywhere',
              style: headerstyle(),
            ),
            SizedBox(height: 50.0),
            Expanded(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 20.0),
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xFF2f2822),
                          border: Border.all(style: BorderStyle.none),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 20.0)
                          ]),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            ImageAsset.send_package,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Send Package',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/sendpackagelist');
                    },
                  ),
//                 Container(
//                   padding:  EdgeInsets.all(10.0),
//                   margin: EdgeInsets.only(bottom: 20.0),
//                   height: 100.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       color: Color(0xFFf69e7b),
//                       border: Border.all(style: BorderStyle.none),
//                       boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 20.0)]
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       Image.asset(ImageAsset.delivery,),
//                       SizedBox(width: 10.0),
//                       Text('Receive Package',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w600),),
//                     ],
//                   ),
//                 ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xFFffc95a),
                          border: Border.all(style: BorderStyle.none),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 20.0)
                          ]),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            ImageAsset.delivery_anywhere,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Track Package',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                launchWhatsApp(phone: '233559418144');
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xFF075E54),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Let\'s Chat on Whatsapp',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
              });
  }

  void launchWhatsApp({
    @required String phone,
    //@required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone";
      } else {
        return "whatsapp://send?phone=$phone";
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
        builder: (context){
          return  AlertDialog(title: Text('Error',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w500),),content: Text('Could not launch whatsapp'),);
        }
      );
    }
  }
}
/*
class gridworks {
  static Widget grid(context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 1,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(46, 49, 49, 0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  child: ClipOval(
                    child: Image.asset('assets/images/delivery.png',
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Send Package',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/sendpackage');
          },
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(46, 49, 49, 0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                child: ClipOval(
                  child: Image.asset('assets/images/receive_package2.png',
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1.5,
              ),
              Text(
                'Receive Package',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 2.5,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ],
    );
  }
}
*/
