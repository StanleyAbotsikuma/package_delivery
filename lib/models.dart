import 'package:flutter/foundation.dart';

class PackageData {
  PackageData({
    this.className,
    this.objectId,
    this.createdAt,
    this.updatedAt,
    this.item,
    this.requestId,
    this.category,
    this.weight,
    this.comment,
    this.price,
  });

  String className;
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  String item;
  String requestId;
  String category;
  String weight;
  String comment;
  String price;

  factory PackageData.fromJson(dynamic json) => PackageData(
        className: json["className"],
        objectId: json["objectId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        item: json["item"],
        requestId: json["request_id"],
        category: json["category"],
        weight: json["weight"],
        comment: json["comment"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "objectId": objectId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "item": item,
        "request_id": requestId,
        "category": category,
        "weight": weight,
        "comment": comment,
        "price": price,
      };
}

class UserData {
  String className;
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  String requestId;
  String firstname;
  String surname;
  String location;
  String telephone;
  String email;
  String gpaddress;
  String lat;
  String lng;

  UserData(
      {this.className,
      this.objectId,
      this.createdAt,
      this.updatedAt,
      this.requestId,
      this.firstname,
      this.location,
      this.surname,
      this.telephone,
      this.email,
      this.gpaddress,
      this.lng,
      this.lat});
  factory UserData.fromJson(dynamic json) => UserData(
        className: json["className"],
        objectId: json["objectId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        requestId: json["request_id"],
        firstname: json["firstname"],
        location: json['location'],
        surname: json['surname'],
        telephone: json['telephone'],
        email: json['email'],
        gpaddress: json['gpaddress'],
        lng: json['lng'],
        lat: json['lat'],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "objectId": objectId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "request_id": requestId,
        "firstname": firstname,
        "location": location,
        "surname": surname,
        "telephone": telephone,
        "email": email,
        "gpaddress": gpaddress,
        "lng": lng,
        "lat": lat,
      };
}

class Places {
  String name;
  String id;
  Places(this.name, this.id);
}

class Location {
  String lat;
  String lng;

  Location(this.lat, this.lng);
}

class SenderLocation with ChangeNotifier {
  String _location = 'No location';
  String _lat = '';
  String _long = '';

  String get location => _location;
  String get lat => _lat;
  String get long => _long;

  setLocation({String location}) {
    _location = location;
    notifyListeners();
  }

  setLat({String lat}) {
    _lat = lat;
    notifyListeners();
  }

  setLong({String long}) {
    _long = long;
    notifyListeners();
  }
}

class ReceiverLocation with ChangeNotifier {
  String _location = 'No location';

  String get location => _location;

  set setLocation(String value) {
    _location = value;
    notifyListeners();
  }
}

class Request {
  Request({
    this.className,
    this.objectId,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.requestId,
    this.status,
    this.riderId,
    this.riderfullname,
  });

  String className;
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  String requestId;
  String status;
  String riderId;
  String riderfullname;

  factory Request.fromJson(dynamic json) => Request(
        className: json["className"],
        objectId: json["objectId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        userId: json["user_id"],
        requestId: json["request_id"],
        status: json["status"],
        riderId: json['riderId'],
        riderfullname: json['riderfullname'],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "objectId": objectId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_id": userId,
        "request_id": requestId,
        "status": status,
        "riderfullname": riderfullname,
        "riderId": riderId
      };
}

class Courier {
  String name;
  String price;
  String status;

  Courier({this.name, this.price, this.status});

  factory Courier.fromJson(dynamic json) => Courier(
        name: json["name"],
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "status": status,
      };
}

class ImageGet {
  String imageId;
  var imageFile;

  ImageGet({this.imageId, this.imageFile});

  factory ImageGet.fromJson(dynamic json) => ImageGet(
        imageId: json["imageId"],
        imageFile: json["imageFile"],
      );

  Map<String, dynamic> toJson() => {
        "imageId": imageId,
        "imageFile": imageFile,
        };

}

class RiderData {
  String riderOthername;
  String riderSurname;
  String riderTel;
  String riderLicense;
  String riderId;

  RiderData(
      {this.riderOthername,
      this.riderSurname,
      this.riderTel,
      this.riderLicense,
      this.riderId});

  factory RiderData.fromJson(dynamic json) => RiderData(
        riderOthername: json["riderOthername"],
        riderSurname: json["riderSurname"],
        riderTel: json["riderTel"],
        riderLicense: json["riderLicense"],
        riderId: json["riderId"],
      );

  Map<String, dynamic> toJson() => {
        "riderOthername": riderOthername,
        "riderSurname": riderSurname,
        "riderTel": riderTel,
        "riderLicense": riderLicense,
        "riderId": riderId,

      };
}



class ReceiverData {
  String className;
  String objectId;
  DateTime createdAt;
  DateTime updatedAt;
  String request_id;
  String firstname;
  String surname;
  String location;
  String contact;
  String email;
  String lat;
  String lng;

  ReceiverData(
      {this.className,
      this.objectId,
      this.createdAt,
      this.updatedAt,
      this.request_id,
      this.firstname,
      this.location,
      this.surname,
      this.contact,
      this.email,
     
      this.lng,
      this.lat});
  factory ReceiverData.fromJson(dynamic json) => ReceiverData(
        className: json["className"],
        objectId: json["objectId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        request_id: json["request_id"],
        firstname: json["firstname"],
        location: json['location'],
        surname: json['surname'],
        contact: json['contact'],
        email: json['email'],
        
        lng: json['lng'],
        lat: json['lat'],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "objectId": objectId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "request_id": request_id,
        "firstname": firstname,
        "location": location,
        "surname": surname,
        "contact": contact,
        "email": email,
                "lng": lng,
        "lat": lat,
      };

    
}