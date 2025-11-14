import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseConfig {
  static Future<void> init() async {
    await Parse().initialize(
      'SMasdvynCgrU3zZH6e5bJV0ek6n2UOexLN1iTbLT',
      'https://parseapi.back4app.com',
      clientKey: 'PLYHBcCIQbMiCW04IK88uXVDG2WQelUGMlY03vM0',
      autoSendSessionId: true,
    );
  }
}
