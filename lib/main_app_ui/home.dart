import 'package:flutterchallenge/database/database_service.dart';
import 'package:flutterchallenge/dtos/application_data.dart';
import 'package:flutterchallenge/main_app_ui/utils/fonts.dart';
import 'package:flutterchallenge/main_app_ui/widgets/loading_dialog.dart';
import 'package:flutterchallenge/main_app_ui/widgets/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class Home extends StatefulWidget {

  DatabaseService dbService;
  Home(this.dbService);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  // Fetching an instance of the monitoring service
  final service = FlutterBackgroundService();

  // Status 0:In Progress, 1:Complete Successfully, 2:Failed
  Set<int> status = {0};
  final int maxAppsAllowed = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Padding( padding: EdgeInsets.all(screenWidth*0.01), child: const Image(image: AssetImage("assets/icons/ia_logo.png"),)),
          title: Padding( padding: EdgeInsets.all(screenWidth*0.05), child: const Image(image: AssetImage("assets/icons/logoText.png"), color: Colors.white,)),
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight*0.04,),
            Text("Enable feature on these Apps", style: Fonts.header2(color: Colors.white, underLine: true, isItalic: true),),
            SizedBox(height: screenHeight*0.04,),
            _addAppsButton(context),
            SizedBox(height: screenHeight*0.03,),
            _listOfMonitoringApps(context)
          ],
        )
    );
  }

  Future<void> restartMonitoringService() async {
    debugPrint("Restarting Monitoring Service");
    status.clear();
    status = {0};

    if(await service.isRunning()) {
      debugPrint("Stopping monitoring service");
      // service.invoke(STOP_MONITORING_SERVICE_KEY);
    }

    await _waitForMonitoringServiceToStop();

    await _startMonitoringService();

    // Determine status of loading window
    if(await service.isRunning()) {
      status.clear();
      status = {1};
      return;
    }
    else{
      status.clear();
      status = {2};
    }

  }

  Future<void> _waitForMonitoringServiceToStop() async{
    debugPrint("Waiting for monitoring service to stop, [Max 3 seconds]");
    int retry = 0;
    while(retry++<3 && await service.isRunning()) {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("Waiting for monitoring service to stop...");
    }

    if(await service.isRunning()){
    debugPrint("*********************MONITORING SERVICE HASN'T STOPPED YET!!!!*******************");
    }
  }

  Future<void> _startMonitoringService() async{
    int retry = 0;
    while(retry++<3 && !await service.startService()) {
      await Future.delayed(const Duration(seconds: 1));
      debugPrint("Starting monitoring service");
    }

    if(await service.isRunning()){
      debugPrint("Monitoring Service Started!");
    }
  }

  int getStatus() {
    return status.last;
  }

  onComplete() {
    Navigator.of(context).pop();
    setState(() {});
  }

  onDelete(String appId) async {
    await widget.dbService.removeAppData(appId);
    Navigator.of(context).pop();
    restartMonitoringService();
    LoadingBar.showLoadingDialog(
        parentContext: context,
        loadingText: "Saving...",
        statusFunction: getStatus,
        onComplete: onComplete,
        onError: onFailure,
        onTimeout: onFailure);
  }

  onFailure() {
    Navigator.pop(context);
  }



  Widget _addAppsButton(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: InkWell(
        onTap: (){
          showInstalledAppsListViewDialog(context);
        },
        child: Column(
          children: [
            Icon(Icons.add_circle_outline_outlined, size: screenWidth*0.15,),
            SizedBox(height: screenHeight*0.01,),
            const Text("Add Application")
          ],
        ),
      ),
    );
  }

  Widget _listOfMonitoringApps(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
        ),
        child: Container(
          height: screenHeight*0.5,
          width: screenWidth*0.9,
          padding: EdgeInsets.all(screenWidth*0.05),
          child: widget.dbService.getAllAppData().isNotEmpty
              ? ListView.separated(
              separatorBuilder: (BuildContext context, int index){
                return SizedBox(height: screenHeight*0.02,);
              },
              itemCount: widget.dbService.getAllAppData().length,
              itemBuilder: (BuildContext context, int index){
                  ApplicationData appInfo = widget.dbService.getAllAppData().elementAt(index);
                  return ListTile(
                    contentPadding: EdgeInsets.all(screenWidth*0.025),
                    leading: appInfo.icon != null
                        ? Image.memory(appInfo.icon!, width: screenWidth*0.1)
                        : Icon(Icons.arrow_forward_ios, size: screenWidth*0.05),
                    title: Text(appInfo.appName, style: const TextStyle(fontStyle: FontStyle.italic),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    //tileColor: Theme.of(context).colorScheme.primary,
                    trailing: InkWell(
                        onTap: () {
                          YesNoDialog(
                            displayText: 'Delete?',
                            acceptText: 'Yes',
                            acceptFunction: () => onDelete(appInfo.appId),
                            rejectText: 'No',
                            rejectFunction: onFailure,
                          ).showBox(context);
                        },
                        child: Icon(Icons.delete, color: Colors.redAccent, size: screenWidth*0.07,)
                    ),
                  );
                }
              )
              : Column(
                children: [
                  SizedBox(height: screenHeight*0.08,),
                  Icon(Icons.filter_none, size: screenWidth*0.35, color: Colors.black54),
                  SizedBox(height: screenHeight*0.03,),
                  const Text("No Applications have been added!")
                ],
              )
        ),
      ),
    );
  }

  showInstalledAppsListViewDialog(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    Map<dynamic, ApplicationData> selectedApps = widget.dbService.getBoxAsMap();

    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context, Function(void Function()) setStateDialog){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(screenWidth*0.02),
                  height: screenHeight*0.8,
                  width: screenWidth*0.9,
                  child: FutureBuilder<List<AppInfo>>(
                      future: InstalledApps.getInstalledApps(true, true),
                      builder: (context, AsyncSnapshot<List<AppInfo>> appsList) {
                        if(appsList.data == null) {
                          return _showCircularLoading(context);
                        }
                        else if(appsList.data!.isEmpty) {
                          return const Text("No App data found!");
                        }

                        List<AppInfo> apps = appsList.data!;
                        return _listOfInstalledApps(context, apps, selectedApps, setStateDialog);
                      }
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget _listOfInstalledApps(BuildContext context, List<AppInfo> apps, Map<dynamic, ApplicationData> selectedApps, Function(void Function()) setStateDialog){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight*0.02,),
        Text("Select Applications [${selectedApps.keys.length}/$maxAppsAllowed]", style: TextStyle(fontSize: screenWidth*0.04),),
        SizedBox(height: screenHeight*0.04,),
        SizedBox(
          height: screenHeight*0.6,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      AppInfo appInfo = apps[index];
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        elevation: selectedApps.containsKey(appInfo.packageName) ? 1 : 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(screenWidth*0.02),
                          selectedColor: Colors.white,
                          selectedTileColor: Theme.of(context).colorScheme.primary,
                          selected: selectedApps.containsKey(appInfo.packageName),
                          onTap: selectedApps.containsKey(appInfo.packageName)
                              ? (){
                            setStateDialog((){
                              selectedApps.remove(appInfo.packageName!);
                            });
                          }
                              :() {
                            if(selectedApps.length < maxAppsAllowed) {
                              setStateDialog(() {
                                selectedApps.putIfAbsent(
                                    appInfo.packageName!, () =>
                                    ApplicationData(
                                        appInfo.name!, appInfo.packageName!,
                                        appInfo.icon));
                              });
                            } else {
                              // Show Dialog
                              _maxAppsReachedAlertDialog(context);
                            }
                          },
                          leading: Image.memory(apps[index].icon!, width: screenWidth*0.1),
                          title: Text(apps[index].name!),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        const Spacer(),
        MaterialButton(
          onPressed: () async {
            if(selectedApps.keys.toSet().difference(widget.dbService.getAllAppPackageNames().toSet()).isNotEmpty
            || widget.dbService.getAllAppPackageNames().toSet().difference(selectedApps.keys.toSet()).isNotEmpty) {
              await widget.dbService.updateAllAppData(
                  selectedApps.values.toList());
              restartMonitoringService();
              Navigator.of(context).pop();
              LoadingBar.showLoadingDialog(
                  parentContext: context,
                  loadingText: "Saving...",
                  statusFunction: getStatus,
                  onComplete: onComplete,
                  onError: onFailure,
                  onTimeout: onFailure);
            } else {
              Navigator.of(context).pop();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.blue,
          child: const Text("Done"),
        ),
        const Spacer(),
      ],
    );
  }

  _maxAppsReachedAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Oops! Cannot add more apps."),
        content: const Text("Please remove an app if you wish to add this app."),
        actions: [
          TextButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Ok"))
        ],
      )
    );
  }

  Widget _showCircularLoading(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      child: SizedBox(
          height: screenHeight*0.1,
          width: screenWidth*0.4,
          child: Column(
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: screenHeight*0.02,),
              const Text("Loading Installed Apps")
            ],
          )
      ),
    );
  }

}