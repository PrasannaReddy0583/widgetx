import 'package:json_annotation/json_annotation.dart';
import '../constants/device_frames.dart';

class DeviceFrameConverter implements JsonConverter<DeviceFrame, String> {
  const DeviceFrameConverter();

  @override
  DeviceFrame fromJson(String json) {
    // Map string identifiers to DeviceFrame instances
    switch (json) {
      case 'iphone14':
        return DeviceFrame.iphone14;
      case 'iphone14Pro':
        return DeviceFrame.iphone14Pro;
      case 'ipadAir':
        return DeviceFrame.ipadAir;
      case 'pixel7':
        return DeviceFrame.pixel7;
      case 'galaxyS23':
        return DeviceFrame.galaxyS23;
      case 'desktop':
        return DeviceFrame.desktop;
      default:
        return DeviceFrame.iphone14; // Default fallback
    }
  }

  @override
  String toJson(DeviceFrame deviceFrame) {
    // Map DeviceFrame instances to string identifiers
    if (deviceFrame == DeviceFrame.iphone14) return 'iphone14';
    if (deviceFrame == DeviceFrame.iphone14Pro) return 'iphone14Pro';
    if (deviceFrame == DeviceFrame.ipadAir) return 'ipadAir';
    if (deviceFrame == DeviceFrame.pixel7) return 'pixel7';
    if (deviceFrame == DeviceFrame.galaxyS23) return 'galaxyS23';
    if (deviceFrame == DeviceFrame.desktop) return 'desktop';
    return 'iphone14'; // Default fallback
  }
}
