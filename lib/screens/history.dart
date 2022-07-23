import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packagedelivery/screens/delivered.dart';
import 'package:packagedelivery/screens/drawer_menu.dart';
import 'package:packagedelivery/screens/pending_delivery.dart';
import 'package:packagedelivery/screens/transit_delivery.dart';
import 'package:packagedelivery/screens/package_assigned.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.sort,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     _scaffoldKey.currentState.openDrawer();
        //   },
        // ),
        title: Text(
          "Track Package",
          style: TextStyle(color: Colors.black,fontWeight:FontWeight.w800),
        ),
       // backgroundColor: Color(0xFFffc95a),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 1.0),
          insets: EdgeInsets.symmetric(horizontal:20.0)
        ),
          
          unselectedLabelColor: Color(0xFF2f2822),
          tabs: [
            Tab(
              icon: Icon(FontAwesomeIcons.motorcycle),
              text: 'On-going',
              
            ),
            
            Tab(
              icon: Icon(FontAwesomeIcons.peopleCarry),
              text: 'Delivered',
            ),
          ],
        ),
      
        ),
      //drawer: DrawerMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [PendingDelivery(),Delivered()],
      ),
    );
  }
}
