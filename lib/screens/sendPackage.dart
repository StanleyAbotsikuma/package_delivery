import 'package:dio/dio.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packagedelivery/screens/location_search.dart';
import 'package:packagedelivery/utility/constant.dart';
import 'package:packagedelivery/utility/size_config.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:device_info/device_info.dart';
import '../models.dart';
import 'drawer_menu.dart';

class SendPackage extends StatefulWidget {
  @override
  _SendPackageState createState() => _SendPackageState();
}

class _SendPackageState extends State<SendPackage> {
  int _currentStep = 0;
  String Loc1 = 'No location';
  String latLocationSender;
  String lngLocationSender;

  String Loc2 = 'No location';
  String lngLocationReceiver;
  String latLocationReceiver;


  bool saveStatus = false;
  String id;

  // ignore: must_call_super
  void initState() {
    super.initState();
    getDeviceId();
  }

  List<ListTile> searchedLocation = [
    ListTile(
      title: Text('type to start searching'),
    )
  ];
  String searchText;
  GlobalKey<FormBuilderState> _formKeySender = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> _formKeyPackage = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> _formKeyReceiver = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _senderFormNode = FocusScopeNode();

  TextEditingController _searchController = TextEditingController();

  final _senderData = UserData();
  final _recieverData = UserData();
  final _packageData = PackageData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: DrawerMenu(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Send Package',
          style: TextStyle(
              color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
      body: FAStepper(
        steps: _steps(),
        type: FAStepperType.horizontal,
        currentStep: _currentStep,
        titleIconArrange: FAStepperTitleIconArrange.column,
        onStepContinue: () {
          setState(() {
            if (_currentStep == 0) {
              var senderForm = _formKeySender.currentState.saveAndValidate();
              if (this._currentStep < this._steps().length - 1) {
                if (senderForm) {
                  _senderData.firstname =
                      _formKeySender.currentState.value['firstname'];
                  _senderData.surname =
                      _formKeySender.currentState.value['surname'];
                  _senderData.email =
                      _formKeySender.currentState.value['email'];
                  _senderData.telephone = _formKeySender
                      .currentState.value['telephone']
                      .toString()
                      .substring(4);
                  _senderData.location = Loc1;
                  _senderData.gpaddress =
                      _formKeySender.currentState.value['gp_address'];
                  _currentStep++;
                }
              }
            } else if (_currentStep == 1) {
              var packageForm = _formKeyPackage.currentState.saveAndValidate();
              if (this._currentStep < this._steps().length - 1) {
                if (packageForm) {
                  _packageData.category =
                      _formKeyPackage.currentState.value['package_category'];
                  // _packageData.weight =
                  //     _formKeyPackage.currentState.value['weight'];
                  _packageData.comment =
                      _formKeyPackage.currentState.value['comment'];

                  print(_packageData.category);
                  _currentStep++;
                }
              }
            } else if (_currentStep == 2) {
              Navigator.pushNamed(context, '/summery');
              var receivedForm = _formKeyReceiver.currentState.saveAndValidate();
              if (this._currentStep < this._steps().length - 1) {
                if (receivedForm) {
                  _recieverData.firstname =
                      _formKeyReceiver.currentState.value['firstname'];
                  _recieverData.surname =
                      _formKeyReceiver.currentState.value['surname'];
                  _recieverData.email =
                      _formKeyReceiver.currentState.value['email'];
                  _recieverData.telephone = _formKeyReceiver
                      .currentState.value['telephone']
                      .toString()
                      .substring(4);
                  _recieverData.location = _formKeyReceiver
                      .currentState.value['sender_location_text'];
                  ;
                  _recieverData.gpaddress =
                      _formKeyReceiver.currentState.value['gp_address'];
                  Navigator.pushNamed(context, '/summery');
                 // _currentStep++;
                }
              }

            } else if (_currentStep == 3) {
              var requestId = generateRequestId(packageType: _packageData.category);
              saveInfo(requestId: requestId);
              saveStatus = true;
              Navigator.pushNamed(context, '/history');
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (this._currentStep > 0) {
              _currentStep--;
            }
          });
        },
      ),
    );
  }

  getDeviceId() async {
    var constant = Constant();
    this.id = await constant.setDeviceInfo();
  }

  saveSender({@required String requestId}) async {
    var senderDatabase = ParseObject('sender')
      ..set('firstname', _senderData.firstname)
      ..set('surname', _senderData.surname)
      ..set('email', _senderData.email)
      ..set('request_id', '$requestId')
      ..set('contact', _senderData.telephone)
      ..set('location', Loc1)
      ..set('lat', latLocationSender)
      ..set('lng', lngLocationSender);
    var saveUser = await senderDatabase.save();
  }

  savePackage({@required String requestId}) async {
    var packageDatabase = ParseObject('package')
      ..set('category', _packageData.category)
      //..set('weight', _packageData.weight)
      ..set('comment', _packageData.comment)
      ..set('request_id', '$requestId');

    var savePackage = await packageDatabase.save();
    print(savePackage);
  }

  saveReceiver({@required String requestId}) async {
    var receiverDatabase = ParseObject('receiver')
      ..set('firstname', _recieverData.firstname)
      ..set('surname', _recieverData.surname)
      ..set('email', _recieverData.email)
      ..set('request_id', '$requestId')
      ..set('contact', _recieverData.telephone)
      ..set('location', Loc2)
      ..set('lat', latLocationReceiver)
      ..set('lng', lngLocationReceiver);

    var saveUser = await receiverDatabase.save();
    print(saveUser);
  }

  saveRequest({@required String requestId}) async {
    var requestDatabase = ParseObject('request')
      ..set('user_id', this.id)
      ..set('request_id', '$requestId');

    var saveReq = await requestDatabase.save();
    print(saveReq);
  }

  saveInfo({@required String requestId}) async {
    await Parse().initialize(Constant.APP_ID, Constant.SERVER_URL,
        appName: Constant.APP_NAME,
        debug: true,
        clientKey: Constant.CLIENT_KEY);
    saveSender(requestId: requestId);
    savePackage(requestId: requestId);
    saveReceiver(requestId: requestId);
    saveRequest(requestId: requestId);
  }

  String generateRequestId({@required String packageType}) {
    var cat;
    switch (packageType) {
      case 'electronics':
        cat = 'E';
        break;
      case 'document':
        cat = 'D';
        break;
      case 'food':
        cat = 'F';
        break;
    }
    var time = new DateTime.now().millisecondsSinceEpoch;
    var id = '$time${1000 + Random().nextInt(9999 - 1000)}';
    var requestId = 'PDS${id.substring(11)}$cat';
    return requestId;
  }

  getLatLong(location,type) async{
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    String apiKey = Constant.APIKEY;
    String request = '$baseUrl?place_id=${location.id}&key=$apiKey';
    Response response = await Dio().get(request);
   // var locations = Location(response.data['result']['geometry']['location']['lat'], response.data['result']['geometry']['location']['lng']);

    if(type == "sender"){
      setState(() {
        Loc1 = location.name;
        lngLocationSender =  response.data['result']['geometry']['location']['lng'].toString();
        latLocationSender = response.data['result']['geometry']['location']['lat'].toString();
      });
    }

    else if(type == "receiver"){
      setState(() {
        Loc2 = location.name;
        lngLocationReceiver =  response.data['result']['geometry']['location']['lng'].toString();
        latLocationReceiver = response.data['result']['geometry']['location']['lat'].toString();
      });
    }

  }

  List<FAStep> _steps() {
    return [
      FAStep(
        title: Text('Sender Details'),
        content: Container(
          child: FormBuilder(
            key: _formKeySender,
            child: FocusScope(
              node: _senderFormNode,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    initialValue: _senderData.firstname,
                    attribute: 'firstname',
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'Firstname',
                        icon: Icon(
                          FontAwesomeIcons.user,
                          size: 20.0,
                        )),
                    validators: [FormBuilderValidators.required()],
                    onEditingComplete: () => _senderFormNode.nextFocus(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FormBuilderTextField(
                    initialValue: _senderData.surname,
                    attribute: 'surname',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'Surname',
                        icon: Icon(
                          FontAwesomeIcons.user,
                          size: 20.0,
                        )),
                    textInputAction: TextInputAction.next,
                    validators: [FormBuilderValidators.required()],
                    onEditingComplete: () => _senderFormNode.nextFocus(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FormBuilderPhoneField(
                    initialValue: _senderData.telephone,
                    attribute: 'telephone',
                    decoration: InputDecoration(
                      helperText: 'eg. Enter your 10 digits number',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'Contact No.',
                      icon: Icon(
                        FontAwesomeIcons.phoneAlt,
                        size: 20.0,
                      ),
                    ),
                    validators: [FormBuilderValidators.minLength(14)],
                    defaultSelectedCountryIsoCode: 'Gh',
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _senderFormNode.nextFocus(),
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderTextField(
                    initialValue: _senderData.email,
                    attribute: 'email',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'Email',
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                          size: 20.0,
                        )),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _senderFormNode.nextFocus(),
                    validators: [
                      FormBuilderValidators.email(),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderDropdown(
                    initialValue: 'no data',
                    attribute: "sender_location",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'Location',
                        icon: Icon(
                          FontAwesomeIcons.streetView,
                          size: 20.0,
                        )),
                    validators: [FormBuilderValidators.required()],
                    onChanged: (value) async {
                      if (value == 'other') {
                        var pickupLocationDialog = Dialog(
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 50.0),
                          child: LocationSearch(),
                        );
                        var location = await showDialog(
                          context: context,
                          child: pickupLocationDialog,
                          barrierDismissible: true,
                        );

                        if(location != null){
                          getLatLong(location,"sender");
                        }

                      }
                    },
                    items: _location(),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.locationArrow,
                          size: 13.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                            child: Text(
                          '$Loc1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderTextField(
                    initialValue: _senderData.gpaddress,
                    attribute: 'gp_address',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'GP Address',
                        icon: Icon(
                          FontAwesomeIcons.mapMarkedAlt,
                          size: 20.0,
                        )),
                    textInputAction: TextInputAction.done,
                  )
                ],
              ),
            ),
          ),
        ),
        state: this._getState(0),
        isActive: this._getStatus(0),
      ),
      FAStep(
        title: Text('Package Details'),
        content: Container(
          child: FormBuilder(
            key: _formKeyPackage,
            child: Column(
              children: <Widget>[
                FormBuilderDropdown(
                    initialValue: _packageData.category ?? 'electronics',
                    attribute: "package_category",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        labelText: 'Category',
                        icon: Icon(
                          FontAwesomeIcons.streetView,
                          size: 20.0,
                        )),
                    validators: [FormBuilderValidators.required()],
                    items: _packageCategory()),
                SizedBox(
                  height: 20.0,
                 ),
                // FormBuilderTextField(
                //   initialValue: _packageData.weight,
                //   keyboardType: TextInputType.number,
                //   attribute: 'weight',
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       contentPadding:
                //           EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                //       labelText: 'Weight',
                //       icon: Icon(
                //         FontAwesomeIcons.weight,
                //         size: 20.0,
                //       ),
                //       suffixText: 'lb'),
                // ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.commentAlt,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                        child: Text(
                            'Any additional information you would like to share about the package..'))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  initialValue: _packageData.comment,
                  attribute: 'comment',
                  minLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      labelText: 'Comment',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ],
            ),
          ),
        ),
        state: this._getState(1),
        isActive: this._getStatus(1),
      ),
      FAStep(
        title: Text('Receiver Details'),
        content: Container(
          child: FormBuilder(
            key: _formKeyReceiver,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  initialValue: _recieverData.firstname,
                  attribute: 'firstname',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'Firstname',
                      icon: Icon(
                        FontAwesomeIcons.user,
                        size: 20.0,
                      )),
                  validators: [FormBuilderValidators.required()],
                ),
                SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  initialValue: _recieverData.surname,
                  attribute: 'surname',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'Surname',
                      icon: Icon(
                        FontAwesomeIcons.user,
                        size: 20.0,
                      )),
                  validators: [FormBuilderValidators.required()],
                ),
                SizedBox(
                  height: 20.0,
                ),
                FormBuilderPhoneField(
                  initialValue: _recieverData.telephone,
                  attribute: 'telephone',
                  defaultSelectedCountryIsoCode: 'Gh',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                    labelText: 'Contact No.',
                    icon: Icon(
                      FontAwesomeIcons.phoneAlt,
                      size: 20.0,
                    ),
                  ),
                  validators: [FormBuilderValidators.minLength(14)],
                ),
                SizedBox(height: 20.0),
                FormBuilderTextField(
                  initialValue: _recieverData.email,
                  attribute: 'email',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'Email',
                      icon: Icon(
                        FontAwesomeIcons.envelope,
                        size: 20.0,
                      )),
                  validators: [FormBuilderValidators.email()],
                ),
                SizedBox(height: 30.0),
                FormBuilderDropdown(
                  initialValue: 'no data',
                  attribute: "receiver_location",
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'Location',
                      icon: Icon(
                        FontAwesomeIcons.streetView,
                        size: 20.0,
                      )),
                  validators: [FormBuilderValidators.required()],
                  onChanged: (value) async {
                    if (value == 'other') {
                      var pickupLocationDialog = Dialog(
                        insetPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 50.0),
                        child: LocationSearch(),
                      );
                      var location = await showDialog(
                        context: context,
                        child: pickupLocationDialog,
                        barrierDismissible: true,
                      );

                      if(location != null){
                        getLatLong(location,"receiver");
                      }

                    }
                  },
                  items: _location(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.locationArrow,
                        size: 13.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: Text(
                          Loc2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                FormBuilderTextField(
                  initialValue: _recieverData.gpaddress,
                  attribute: 'gp_address',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      labelText: 'GP Address',
                      icon: Icon(
                        FontAwesomeIcons.mapMarkedAlt,
                        size: 20.0,
                      )),
                )
              ],
            ),
          ),
        ),
        state: this._getState(2),
        isActive: this._getStatus(2),
      ),
      /*
      FAStep(
        title: Text('Summery'),
        content: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    color: Color(0xFF394989),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.truckLoading,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Sender Details',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Raleway'),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Name',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${_senderData.firstname} ${_senderData.surname} ',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Raleway'),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Contact',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('${_senderData.telephone}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('${_senderData.email}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('$Loc1',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0XFF3b2e5a),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.shoppingBag,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Package Details',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Raleway'),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Category',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('${_packageData.category}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Weight',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text('${_packageData.weight}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0xFF006a71),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.peopleCarry,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Receiver Details',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: 'Raleway'))
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Name',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              '${_recieverData.firstname} ${_recieverData.surname}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Contact',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('${_recieverData.telephone}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('${_recieverData.email}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('$Loc2',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Raleway')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (!saveStatus)
                ? Container()
                : Positioned.fill(
                    child: Container(
                        color: Colors.white38,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Saving Data..')
                          ],
                        ))))
          ],
        ),
        state: this._getState(3),
        isActive: this._getStatus(3),
      )
       */
    ];
  }

  FAStepstate _getState(int index) {
    return (this._currentStep > index)
        ? FAStepstate.complete
        : FAStepstate.indexed;
  }

  bool _getStatus(int index) {
    return (this._currentStep == index) ? true : false;
  }
}

List<DropdownMenuItem> _packageCategory() {
  return [
    DropdownMenuItem(
      value: 'food',
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.hamburger,
            size: 15.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Food'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'electronics',
      child: Row(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                  top: -5,
                  left: -2,
                  child: Icon(
                    FontAwesomeIcons.mobile,
                    size: 15.0,
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.laptop,
                    size: 15.0,
                  )),
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Electronics'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'document',
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.file,
            size: 15.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Document'),
        ],
      ),
    ),
  ];
}

List<DropdownMenuItem> _location() {
  return [
    DropdownMenuItem(
      value: 'no data',
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.mapSigns,
            size: 15.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Location'),
        ],
      ),
    ),
    /*
    DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.mapPin,
            size: 15.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Use Current Location'),
        ],
      ),
      value: 'current',
    ),
    */
    DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.map,
            size: 15.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text('Set location from map'),
        ],
      ),
      value: 'other',
      onTap: () {},
    ),
  ];
}
