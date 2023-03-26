import 'dart:async';

import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget{

  final String loadingText;
  final Map<String, String>? messagesMap;
  final Function statusFunction;
  final Function onComplete;
  final Function onError;
  final Function onTimeout;
  final int timeToCheck;
  final int timeoutInSeconds;
  const LoadingBar({required this.loadingText,required this.statusFunction,required this.onComplete,required this.onError,required this.onTimeout, this.timeToCheck=3, this.timeoutInSeconds = 30, this.messagesMap});

  @override
  _LoadingBarState createState() => _LoadingBarState();

  static showLoadingDialog({required BuildContext parentContext, required String loadingText,required Function statusFunction,required Function onComplete,required Function onError,required Function onTimeout, Map<String, String>? messagesMap, int timeToCheck=3, int timeoutInSeconds = 30}){

    return showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder:(context){
          return WillPopScope(
            onWillPop: () async => statusFunction() == 0 ? false : true,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: LoadingBar(loadingText: loadingText, statusFunction: statusFunction, onComplete: onComplete, onError: onError, onTimeout: onTimeout, timeToCheck: timeToCheck, timeoutInSeconds: timeoutInSeconds, messagesMap: messagesMap,),
            ),
          );
        }
    );
  }

}

class _LoadingBarState extends State<LoadingBar> {

  int status = 0;  //0->Loading,1->Completed,2->Failed , 3-> Timeout
  late Widget alertText;
  late Widget alertContent;

  @override
  void initState(){
    super.initState();
    int timePassed = 0;
    Timer.periodic(Duration(seconds: widget.timeToCheck), (timer){
      timePassed = timePassed + widget.timeToCheck;
      int newStatus = timePassed >= widget.timeoutInSeconds
          ? 3
          : widget.statusFunction();

      if(status != newStatus) {
        setState(() {
          status = newStatus;

        });
      }
      if(status ==1){
        timer.cancel();
        Timer(
            const Duration(seconds: 2),(){
          widget.onComplete();
        }
        );
      }
      if(status ==2){
        timer.cancel();
        Timer(
            const Duration(seconds: 2),(){
          widget.onError();
        }
        );
      }
      if(status ==3){
        timer.cancel();
        Timer(
            const Duration(seconds: 2),(){
          widget.onTimeout();
        }
        );
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    if(status == 0) {
      alertText = Center(child: Text(widget.loadingText,style: TextStyle(fontSize: screenWidth*0.06),));
      alertContent = Align(
        child: SizedBox(
          width: screenWidth* 0.3,
          child: const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.black,
          ),
        ),
      );
    }

    if(status == 1){
      alertText = Center(child: Text(_successMessagePresent() ? widget.messagesMap!["successMessage"]! :"Success!",style: TextStyle(fontSize: screenWidth*0.06),));
      alertContent = const Icon(Icons.check_circle_sharp, color: Colors.green, size: 60,);
    }

    if(status == 2){
      alertText = Center(child: Text(_failureMessagePresent() ? widget.messagesMap!["failureMessage"]! : "Failed!",style: TextStyle(fontSize: screenWidth*0.06)));
      alertContent = const Icon(Icons.close_rounded, color: Colors.red, size: 60,);
    }

    if(status == 3){
      alertText = Center(child: Text("Timed Out!", style: TextStyle(fontSize: screenWidth*0.06),),);
      alertContent = const Icon(Icons.close_rounded, color: Colors.yellow, size: 60,);
    }

    return SizedBox(
      height: screenHeight*0.35,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        title: alertText,
        content: alertContent,
      ),
    );

  }

  bool _successMessagePresent(){
    if(widget.messagesMap != null && widget.messagesMap!.containsKey("successMessage")){
      return true;
    }
    else{
      return false;
    }
  }

  bool _failureMessagePresent(){
    if(widget.messagesMap != null && widget.messagesMap!.containsKey("failureMessage")){
      return true;
    }
    else{
      return false;
    }
  }

}