import 'package:device_info_plus/device_info_plus.dart';

class PlatformSizeOffset {
  static getIOSOffset(DeviceInfoPlugin deviceInfo) async {
    IosDeviceInfo device = await deviceInfo.iosInfo;
    if (device.name == 'iPhone 8 Plus') {
      return 100;
    }
    return 200;
  }
}
