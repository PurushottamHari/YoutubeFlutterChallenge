import 'package:flutter/material.dart';

class Fonts {

  // Headers
  static TextStyle header({required double fontSize, bool isItalic = false}) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal
    );
  }

  static TextStyle header1({bool isItalic = false, bool underLine = false}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle header2({bool isItalic = false, Color? color, bool underLine = false}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color ?? Colors.black,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle header3({Color? color, bool isItalic = false, bool underLine = false}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle header4({bool isItalic = false, color = Colors.black, bool underLine = false}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }

  // Content - the font that will be used in the body/descriptions
  static TextStyle content({required double fontSize, bool isItalic = false, color = Colors.black, bool underLine = false}) {
    return TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: underLine ? TextDecoration.underline : TextDecoration.none,
        color: color
    );
  }

  static TextStyle content1({bool isItalic = false, color = Colors.black, bool underLine = false}) {
    return TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: underLine ? TextDecoration.underline : TextDecoration.none,
        color: color
    );
  }

  static TextStyle content2({bool isItalic = false, color = Colors.black,bool underLine=false}) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle content3({bool isItalic = false, color = Colors.black, bool underLine=false}) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color,
      decoration: underLine ? TextDecoration.underline : TextDecoration.none,
    );
  }
}