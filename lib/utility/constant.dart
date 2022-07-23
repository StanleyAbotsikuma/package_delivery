import 'package:device_info/device_info.dart';


import 'dart:convert';
const String keyApplicationName = 'Deliverytest';
const String keyParseApplicationId = 'F085SGjJ6pNrapZbgwq1EI11C6OjTCQucW0MCQlh';
const String keyParseClientKey = 'ErNvFXyWKEn8If6Cwrr6m7a3aNIyz1UwyoruLFWr';
const String keyParseServerUrl = 'https://parseapi.back4app.com/';
const String keyParseLiveServerUrl = 'wss://deliverytest.b4a.io';
const bool keyDebug = false;

class Constant{
  static  String APIKEY     = "AIzaSyDhdkPf3VnKbORBQwj5TnIw53UpCgIuWMI";
  static  String LOCATION   = '7.9465,1.0232';
  static  String APP_ID     = 'F085SGjJ6pNrapZbgwq1EI11C6OjTCQucW0MCQlh';
  static  String APP_NAME   = 'Deliverytest';
  static  String SERVER_URL = 'https://parseapi.back4app.com/';
  static  String CLIENT_KEY = 'ErNvFXyWKEn8If6Cwrr6m7a3aNIyz1UwyoruLFWr';



  Future<String> setDeviceInfo() async{
    DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo _androidDeviceInfo =  await _deviceInfoPlugin.androidInfo;
    // IosDeviceInfo _iosDeviceInfo        = await _deviceInfoPlugin.iosInfo;
    return _androidDeviceInfo.androidId;
  }



}