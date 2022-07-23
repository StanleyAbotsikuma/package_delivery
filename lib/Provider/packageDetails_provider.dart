import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PackageDetailsProvider with ChangeNotifier {
  String category = 'No Category Selected';
 // String weight;
  String comments;
  String item;
  List<Asset> images = List<Asset>();
  bool _submitted = false;
  

  void setProviderDetails({String category, String weight, String comments, String item,var images}) {
    this.category = category;
    //this.weight = weight;
    this.comments = comments;
    this.item = item;
    this.images =  images;
    notifyListeners();
  }
List<Asset> getImages() {
    return images;
  }
  String getCategory() {
    return category;
  }

  // String getWeight() {
  //   return weight;
  // }

  String getComments() {
    return comments;
  }

  String getItem(){
    return item;
  }

  bool getStatus() {
    return _submitted;
  }

  void setStatus() {
    _submitted = true;
  }

  void unset(){
    this.category = 'No Category Selected';
    this.comments = null;
    this.item = null;
   // this.weight = null;
    this._submitted = false;
    this.images = [];
  }
}
