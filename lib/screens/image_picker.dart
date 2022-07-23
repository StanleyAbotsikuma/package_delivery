import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  var imagesList;
  ImagePickerScreen(this.imagesList, {Key key}) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffc95a),
        elevation: 4.0,
        leading:IconButton(
            onPressed: (){
              
              Navigator.pop(context, widget.imagesList);
              //print(widget.imagesList);
            },
            icon: Icon(Icons.arrow_back),
          ),
        title: Text(
          'Image Picker',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => loadAssets(),
            icon: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() {
    if (widget.imagesList != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(widget.imagesList.length, (index) {
          Asset asset = widget.imagesList[index];
          // return AssetThumb(
          //   asset: asset,
          //   width: 300,
          //   height: 300,
          // );
          return  Stack(
          children: <Widget>[
           AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color:Color(0xFFffc95a),
                ),
                onTap: () {
                  setState(() {
                    widget.imagesList.removeAt(index);
                                      });
                },
              ),
            ),
          ],
        );
        }),
      );
    else
      return Container(
        color: Colors.white,
        child: Center(
          child: Text('No Data'),
        ),
      );
  }

  Future<void> loadAssets() async {
    setState(() {
      widget.imagesList = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      widget.imagesList = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }
}
