   import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SenderDetailsProvider with ChangeNotifier {
  String firstname;
  String surname;
  String email;
  String contact;
  String lat;
  String lng;
  String location = 'No Location Selected';
  bool submitted = false;

  void setValues(
      {String firstname,
      String surname,
      String email,
      String contact,
      String lat,
      String lng,
      String location}) {
    this.firstname = firstname;
    this.surname = surname;
    this.email = email;
    this.contact = contact;
    this.lat = lat;
    this.lng = lng;
    this.location = location;
    notifyListeners();
  }

  void setStatus() {
    submitted = true;
  }

  bool getStatus() {
    return submitted;
  }

  String getFirstname() {
    return this.firstname;
  }

  String getSurname() {
    return this.surname;
  }

  String getEmail() {
    return this.email;
  }

  String getContact() {
    return this.contact;
  }

  String getLat() {
    return this.lat;
  }

  String getLng() {
    return this.lng;
  }

  String getLocation() {
    return this.location;
  }

   void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    this.firstname = (await prefs.getString('Ufirstname') ?? '');
    this.surname = (await prefs.getString('Usurname') ?? '');
    this.email = (await prefs.getString('Uemail') ?? '');
    this.contact = (await prefs.getString('Ucontact') ?? '');
    notifyListeners();
  }

  void unset() {
    this.location = 'No Location Selected';
    this.submitted = false;
    this.lat = null;
    this.lng = null;
  }
}
