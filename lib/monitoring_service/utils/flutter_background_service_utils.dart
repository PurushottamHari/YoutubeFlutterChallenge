import 'package:flutterchallenge/monitoring_service/monitoring_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> startMonitoringService() async {
  final monitoringService = FlutterBackgroundService();
  IosConfiguration iosConfiguration = IosConfiguration();


  // Monitoring Service should have an OnBoot Broadcast Receiver Attached as well
  // It would also popup a notification signifying its running status
  AndroidConfiguration androidConfiguration = AndroidConfiguration(
      onStart: onMonitoringServiceStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      initialNotificationTitle: "Flutter Challenge (background).",
      initialNotificationContent: "",

  );

  await monitoringService.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration
  );

  monitoringService.startService();
}