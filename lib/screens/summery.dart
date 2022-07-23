import 'package:flutter/material.dart';


class Summery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFDC830),Color(0xFFF37335)],begin: Alignment.topCenter)
        ),
        child: Stack(
          children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.pages,size: 50.0,color: Colors.white,),
                  Center(child: Text("Summery",style: TextStyle(fontSize: 25.0),))
                ],
              )
          ],
        ),
      ),
    );
  }
}
