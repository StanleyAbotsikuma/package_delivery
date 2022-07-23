import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:packagedelivery/Provider/senderDetails_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
class SenderDetails extends StatefulWidget {
  SenderDetails({Key key}) : super(key: key);

  @override
  _SenderDetailsState createState() => _SenderDetailsState();
}

class _SenderDetailsState extends State<SenderDetails> {
  final _formkey = GlobalKey<FormState>();
  IconData listIconData = Icons.arrow_forward_ios;
  Color iconColor = Colors.grey;

  String firstname;
  String surname;
  String email;
  String contact;
  String lat;
  String lng;
  String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          title: Text(
            'Sender Info',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xFFffc95a),
          actions: [
            Consumer<SenderDetailsProvider>(
              builder: (context, senderModel, child) {
                return FlatButton(
                  onPressed:  ()async {
                     final prefs = await SharedPreferences.getInstance();
                    if (location == null) {
                      location = senderModel.getLocation();
                    }
                    if (_formkey.currentState.validate() &&
                        location != 'No Location Selected') { 
                      _formkey.currentState.save();
                      senderModel.setValues(
                        firstname: firstname,
                        surname: surname,
                        email: email,
                        contact: contact,
                        location: location,
                        lat: lat,
                        lng: lng,
                      );
                      senderModel.setStatus();
                      prefs.setString('Ufirstname',firstname );
                      prefs.setString('Usurname', surname);
                      prefs.setString('Uemail',email );
                      prefs.setString('Ucontact', contact);

                     
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        listIconData = Icons.error_outline;
                        iconColor = Colors.red;
                      });
                    }
                  },
                  child: Text('Done'),
                );
              },
            ),
          ],
        ),
        body: Consumer<SenderDetailsProvider>(
            builder: (context, senderModel, child) {
          return Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              autovalidate: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: senderModel.getFirstname(),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => firstname = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Firstname', icon: Icon(Icons.person)),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: senderModel.getSurname(),
                      keyboardType: TextInputType.name,
                      onSaved: (value) => surname = value,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'Surname', icon: Icon(Icons.person)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: senderModel.getEmail(),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => email = value,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: senderModel.getContact(),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => contact = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        icon: Icon(Icons.phone_android),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Field is required';
                        } else if (value.length < 10 || value.length > 10) {
                          return 'Phone number has to be 10 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      leading: Icon(Icons.location_on),
                      subtitle: location == null
                          ? Text(senderModel.getLocation())
                          : Text(location),
                      title: Text('Pick a Location'),
                      trailing: Icon(
                        listIconData,
                        color: iconColor,
                        size: 16.0,
                      ),
                      onTap: () async {
                        LocationResult result = await showLocationPicker(
                          context,
                          'AIzaSyDhdkPf3VnKbORBQwj5TnIw53UpCgIuWMI',
                          automaticallyAnimateToCurrentLocation: true,
                          //mapStylePath: 'assets/mapStyle.json',
                          myLocationButtonEnabled: true,
                          layersButtonEnabled: true,
                          countries: ['GH'],
                          resultCardAlignment: Alignment.bottomCenter,
                        );
                        setState(() {
                          location = result.address;
                          lat = result.latLng.latitude.toString();
                          lng = result.latLng.longitude.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
