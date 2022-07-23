import 'package:flutter/material.dart';

class PaymentOption extends StatefulWidget {
  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  String _paymode;
  String _collectionPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          'Payment Option',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                if (_paymode == 'momo' && _collectionPoint == 'sender') {
                  showDialog(
                    context: context,
                    builder: (context) => mobileMoneyCardView(),
                  );
                }
              },
              child: Text('Done')),
        ],
        backgroundColor: Color(0xFFffc95a),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Mode',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5.0,
                ),
                DropdownButtonFormField(
                  items: paymentMode(),
                  hint: Text('Payment Mode'),
                  onChanged: (value) {
                    _paymode = value;
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collection Point',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5.0,
                ),
                DropdownButtonFormField(
                  items: collectionPoint(),
                  hint: Text('Collection Point'),
                  onChanged: (value) {
                    _collectionPoint = value;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileMoneyCardView() {
    return Dialog(
      elevation: 0.0,
      child: Container(
        height: 270,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Note our Mobile Money service support only MTN Mobile Money Thank you.',
              style: TextStyle(color: Colors.redAccent),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEAEAEA),
                  border: InputBorder.none,
                  hintText: '10.0'),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEAEAEA),
                  border: InputBorder.none,
                  hintText: 'MTN MoMo Number'),
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
                width: double.infinity,
                height: 50.0,
                child: FlatButton(
                  onPressed: () {},
                  child: Text('Send Payment Request'),
                  color: Color(0xFFffc95a),
                ))
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> paymentMode() {
    return [
      DropdownMenuItem(
        child: Text('Cash'),
        value: 'cash',
      ),
      DropdownMenuItem(
        child: Text('Mobile Money'),
        value: 'momo',
      ),
    ];
  }

  List<DropdownMenuItem> collectionPoint() {
    return [
      DropdownMenuItem(
        child: Text('Sender'),
        value: 'sender',
      ),
      DropdownMenuItem(
        child: Text('Receiver'),
        value: 'receiver',
      ),
    ];
  }

  List<DropdownMenuItem> momoType() {
    return [
      DropdownMenuItem(
        child: Text('MTN Mobile Money'),
        value: 'mtn',
      ),
      DropdownMenuItem(
        child: Text('Vodafone Cash'),
        value: 'vodafone',
      ),
      DropdownMenuItem(
        child: Text('Airtel-Tigo Cash'),
        value: 'airteltigo',
      ),
    ];
  }

  Widget paymentOptions() {
    return DropdownButtonFormField(items: momoType(), onChanged: (value) {});
  }
}
