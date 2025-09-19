import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> analytics() async {
  /**
   * Add an analytics subscriber callback to handle
   * any analytics event triggered in the RTU UI flows
   */

  ScanbotSdk.setAnalyticsSubscriber((analyticsEvent) {
    Logger.root.log(Level.INFO, analyticsEvent.name);
  });
}