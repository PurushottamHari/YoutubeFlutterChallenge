
import 'package:flutterchallenge/dtos/application_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class DatabaseService {

  bool _isInitialized = false;
  // static final Finalizer<Box<ApplicationData>> _finalizer =
  // Finalizer((box) => box.close());


  final String _boxName = "application-data";
  late Box<ApplicationData> _box;

  static Future<DatabaseService> instance() async {
    DatabaseService dbService = DatabaseService();
    await dbService.initializeHive();
    await dbService.registerAdapters();
    await dbService.openBox();
    return dbService;
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
  }

  registerAdapters() {
    if(!_isInitialized) {
      Hive.registerAdapter(ApplicationDataAdapter());
      _isInitialized = true;
    }
  }

  Future<void> openBox() async {
    if(Hive.isBoxOpen(_boxName)) {
      debugPrint("Reopening the box so closing it first!");
      await close();
    }

    debugPrint("Opening the box!");
    _box = await Hive.openBox(_boxName);
  }

  Future<void> close() async {
    if(Hive.isBoxOpen(_boxName)) {
      debugPrint("Closing the box!");
      await _box.close();
      //_finalizer.detach(this);
    } else {
      debugPrint("Box not open!");
    }
  }

  ApplicationData? getAppData(String appId) {
    return _box.get(appId);
  }

  List<ApplicationData> getAllAppData() {
    return _box.values.toList();
  }

  List<String> getAllAppPackageNames() {
    return _box.keys.map((e) => e as String).toList();
  }

  Future<void> addAppData(ApplicationData appData) async {
    debugPrint("Adding ${appData.appId} to box!");
    await _box.put(appData.appId, appData);
  }

  Future<void> addAllAppData(List<ApplicationData> appDatas) async {
    for(ApplicationData appData in appDatas) {
      await addAppData(appData);
    }
  }

  Future<void> updateAllAppData(List<ApplicationData> appDatas) async {
    await _box.clear();
    for(ApplicationData appData in appDatas) {
      await addAppData(appData);
    }
  }

  Map<dynamic, ApplicationData> getBoxAsMap() {
    return _box.toMap();
  }

  Future<void> removeAppData(String appId) async {
    debugPrint("Removing $appId from box!");
    await _box.delete(appId);
  }
}