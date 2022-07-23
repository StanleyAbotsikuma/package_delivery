import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:packagedelivery/Provider/packageDetails_provider.dart';
import 'package:packagedelivery/screens/categoryList.dart';
import 'package:provider/provider.dart';
import 'package:packagedelivery/screens/image_picker.dart';

class PackageDetails extends StatefulWidget {
  PackageDetails({Key key}) : super(key: key);

  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  final _formkey = GlobalKey<FormState>();

  String selectedCategory;
  //String weight;
  String comment;
  String item;
  List<Asset> images = List<Asset>();
  
  List<DropdownMenuItem> _category = [
    DropdownMenuItem(
      child: Text('Select Category'),
      value: 'default',
    ),
    DropdownMenuItem(
      child: Text('Electronic'),
      value: 'electronic',
    ),
    DropdownMenuItem(
      child: Text('Document'),
      value: 'document',
    ),
    DropdownMenuItem(
      child: Text('Food'),
      value: 'food',
    ),
    DropdownMenuItem(
      child: Text('Other'),
      value: 'other',
    )
  ];

void _awaitReturnValueFromSecondScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePickerScreen(images),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      
      if(result == null){
        List<Asset> images = List<Asset>();
  
      }
      else{
images = result;
      }
     // print(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageDetailsProvider>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 4.0,
            title: Text(
              'Package Info',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color(0xFFffc95a),
            actions: [
              FlatButton(
                  onPressed: () {
                    if (selectedCategory == null) {
                      selectedCategory = model.getCategory();
                    }
                    if (_formkey.currentState.validate() && selectedCategory != 'No Category Selected') {
                      _formkey.currentState.save();
                      model.setProviderDetails(
                          category: selectedCategory,
                          //weight: weight,
                          comments: comment,
                          item: item,
                          images:images

                          );
                      model.setStatus();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Done'))
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: model.getItem(),
                      onSaved: (value) =>  item = value,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Package name is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Package Name',
                        icon: Icon(Icons.category),
                      ),
                    ),
                    // SizedBox(
                    //   height: 16.0,
                    // ),
                    // DropdownButton(
                    //   items: _category,
                    //   hint: Text('Select Category'),
                    //   value: selectedCategory,
                    //   isExpanded: true,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedCategory = value;
                    //     });
                    //   },
                    // ),
                    
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      initialValue: model.getComments(),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description  **optional',
                        icon: Icon(
                          Icons.comment,
                        ),
                      ),
                      onSaved: (value) => comment = value,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    ListTile(
                      onTap: () async {
                        var myCategory = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryListView(),
                          ),
                        );
                        setState(() {
                          selectedCategory = myCategory;
                        });
                      },
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Select Category'),
                      subtitle: selectedCategory == null
                          ? Text(model.getCategory())
                          : Text(selectedCategory),
                      leading: Icon(FontAwesomeIcons.layerGroup),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                      ),
                    ),
                    ListTile(
                      onTap: () {
_awaitReturnValueFromSecondScreen(context);
                        //Navigator.pushNamed(context, '/imagePicker',arguments: images);
                      },
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Add Sample Images'),
                      subtitle: images.length > 0? Text('${images.length} images selected'):Text('0 images') ,
                      leading: Icon(FontAwesomeIcons.camera),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
