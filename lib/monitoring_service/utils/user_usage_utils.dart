
import 'package:flutterchallenge/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

Future<Map<String, UsageInfo>> getCurrentUsageStats(Map<String, ApplicationData> appIds) async{
  DateTime endDate = DateTime.now();
  DateTime startDate = endDate.subtract(const Duration(minutes: 3));

  Map<String, UsageInfo> queryAndAggregateUsageStats = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

  List<String> keys = queryAndAggregateUsageStats.keys.toList();
  for(String key in keys) {
    if(!appIds.containsKey(key)) {
      queryAndAggregateUsageStats.remove(key);
    }
  }
  return queryAndAggregateUsageStats;
}

String? checkIfAnyAppHasBeenOpened(
    Map<String, UsageInfo> currentUsage,
    Map<String, UsageInfo> previousUsage,
    Map<String, ApplicationData> monitoredApplicationSet){

  /*
      (i) Last used time updates when an app is opened as well as well then app is closed [Point a and Point b]
      (ii) Foreground total time changes when an app is closed [Point b]
      So to determine the startup, we can check for (i) first, and then to confirm that its not a "App Closing" use case
      we can crosscheck it with the foreground total time use case as well
     */

  for(String appId in monitoredApplicationSet.keys){
    if(currentUsage.containsKey(appId) && previousUsage.containsKey(appId)){
      UsageInfo currentAppUsage = currentUsage[appId]!;
      UsageInfo previousAppUsage = previousUsage[appId]!;

      if(currentAppUsage.lastTimeUsed != previousAppUsage.lastTimeUsed){

        if(currentAppUsage.totalTimeInForeground == previousAppUsage.totalTimeInForeground){
          return appId;
        }

      }

    }
  }

  return null;

}