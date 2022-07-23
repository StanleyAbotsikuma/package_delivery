import 'package:flutter/material.dart';

class CategoryListView extends StatefulWidget {
  CategoryListView({Key key}) : super(key: key);

  final categoryListData = [
    'Phones and Laptops',
    'Documents',
    'Home Appliances',
    'Food',
    'Cosmetics',
    'Other'
  ];

  @override
  _CategoryListView createState() => _CategoryListView();
}

class _CategoryListView extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffc95a),
        elevation: 4.0,
        title: Text(
          'Select Category',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  onTap: () =>
                      Navigator.pop(context, widget.categoryListData[index]),
                  title: Text(widget.categoryListData[index]),
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: widget.categoryListData.length),
      ),
    );
  }
}
