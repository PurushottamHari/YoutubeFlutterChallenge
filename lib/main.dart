import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutterchallenge/alert_dialog_service/overlay_widget.dart';
import 'package:flutterchallenge/database/database_service.dart';
import 'package:flutterchallenge/main_app_ui/home.dart';
import 'package:flutterchallenge/main_app_ui/permissions_screen.dart';
import 'package:flutterchallenge/monitoring_service/utils/flutter_background_service_utils.dart';
import 'package:usage_stats/usage_stats.dart';

void main() async{
  // Start the monitoring service
  await onStart();
  DatabaseService dbService = await DatabaseService.instance();
  bool permissionsAvailable = (await UsageStats.checkUsagePermission())! &&
      await FlutterOverlayWindow.isPermissionGranted();
  runApp(MyApp(
      permissionsAvailable ? Home(dbService) : PermissionsScreen(dbService),
      dbService));
}


onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await startMonitoringService();
}

// This is the isolate entry for the Alert Window Service
// It needs to be added in the main.dart file with the name "overlayMain"...(jugaadu code max by plugin dev)
@pragma("vm:entry-point")
void overlayMain() async {
  debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayWidget()
  ));
}


class MyApp extends StatelessWidget {
  Widget screenToDisplay;

  DatabaseService dbService;

  MyApp(this.screenToDisplay, this.dbService);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screenToDisplay,
    );
  }
}

