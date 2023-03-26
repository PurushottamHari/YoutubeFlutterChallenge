import 'package:flutter/material.dart';
class YesNoDialog{

  final String displayText;
  final String acceptText;
  final String rejectText;
  final Function acceptFunction;
  final Function rejectFunction;
  final bool dismissable;

  YesNoDialog({required this.displayText,required this.acceptText,required this.rejectText,required this.acceptFunction,required this.rejectFunction, this.dismissable = true});

  showBox(BuildContext parentContext){
    final double screenHeight = MediaQuery.of(parentContext).size.height;
    final double screenWidth = MediaQuery.of(parentContext).size.width;

    return showDialog(
        context: parentContext,
        barrierDismissible: dismissable,
        builder: (context){
          return SizedBox(
            height: screenHeight*0.35,
            child: AlertDialog(
              //backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Column(
                children: <Widget>[
                  Center(child:Text(displayText,style: TextStyle(fontSize: screenWidth*0.05))),
                  const Divider(thickness: 5.0,)
                ],
              ),
              content: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () => acceptFunction(),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(acceptText, style: TextStyle(fontSize: screenWidth*0.04),),
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () => rejectFunction(),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(rejectText, style: TextStyle(fontSize: screenWidth*0.04),),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

}