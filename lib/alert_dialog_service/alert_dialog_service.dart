import 'package:flutterchallenge/alert_dialog_service/utils/alert_dialog_utils.dart';

class AlertDialogService {

  // The isolate function for this service has been defined in the main class file!

  static Future<void> createAlertDialog({bool fromTimerService = false}) async {
    await AlertDialogUtils.showDialog();
  }

  static Future<void> closeAlertDialog() async{
    await AlertDialogUtils.closeAlertDialog();
  }
}
