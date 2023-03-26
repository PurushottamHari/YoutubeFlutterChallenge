import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'application_data.g.dart';

@HiveType(typeId: 0)
class ApplicationData {

  @HiveField(0)
  String appId;

  @HiveField(1)
  String appName;

  @HiveField(2)
  Uint8List? icon;

  ApplicationData(this.appName, this.appId, this.icon);
}