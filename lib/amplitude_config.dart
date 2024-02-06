import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class AmplitudeConfig {
  static Amplitude amplitude = Amplitude.getInstance();
  Future<void> init() async {
    amplitude.init("8a892ee4ce8826aa61a32ceea9dbe68b");
  }
}
