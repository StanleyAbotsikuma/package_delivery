import 'package:device_info/device_info.dart';

class DeviceInfo {

  DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  var androidInfoId;

  static final DeviceInfo _instance = DeviceInfo._internal();

  factory DeviceInfo() => _instance;

  DeviceInfo._internal();

  androidId() async{
    DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo _androidDeviceInfo =  await _deviceInfoPlugin.androidInfo;
    androidInfoId = _androidDeviceInfo.androidId;
  }

}