import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutterchallenge/alert_dialog_service/alert_dialog_service.dart';
import 'package:flutterchallenge/database/database_service.dart';
import 'package:flutterchallenge/dtos/application_data.dart';
import 'package:flutterchallenge/monitoring_service/utils/user_usage_utils.dart';
import 'package:usage_stats/usage_stats.dart';



const String STOP_MONITORING_SERVICE_KEY = "stop";
const String SET_APPS_NAME_FOR_MONITORING_KEY = "setAppsNames";
const String APP_NAMES_LIST_KEY = "appNames";

// Entry Point for Monitoring Isolate
@pragma('vm:entry-point')
onMonitoringServiceStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = await DatabaseService.instance();

  Map<String, ApplicationData> monitoredApplicationSet = {};

  // Stop this background service
  _registerListener(service);

  Map<String, UsageInfo> previousUsageSession = await getCurrentUsageStats(monitoredApplicationSet);
  _startTimer(databaseService, monitoredApplicationSet, previousUsageSession);
}

Future<void> _startTimer(DatabaseService databaseService, Map<String, ApplicationData> monitoredApplicationSet, Map<String, UsageInfo> previousUsageSession) async{
  Timer.periodic(const Duration(seconds: 1), (timer) async{
    timer.cancel();
    _setMonitoringApplicationsSet(databaseService, monitoredApplicationSet);
    Map<String, UsageInfo> currentUsageSession = await getCurrentUsageStats(monitoredApplicationSet);
    String? appOpened = checkIfAnyAppHasBeenOpened(currentUsageSession, previousUsageSession, monitoredApplicationSet);
    if(appOpened != null){
      AlertDialogService.createAlertDialog();
    }
    previousUsageSession = currentUsageSession;

    _startTimer(databaseService, monitoredApplicationSet, previousUsageSession);
  });
}

_setMonitoringApplicationsSet(DatabaseService databaseService, Map<String, ApplicationData> monitoredApplicationSet){
  List<ApplicationData> monitoredApps = databaseService.getAllAppData();
  monitoredApplicationSet.clear();

  for(ApplicationData app in monitoredApps){
    monitoredApplicationSet[app.appId] = app;
  }
}

_registerListener(ServiceInstance service){
  service.on(STOP_MONITORING_SERVICE_KEY).listen((event) {
    service.stopSelf();
  });
}

