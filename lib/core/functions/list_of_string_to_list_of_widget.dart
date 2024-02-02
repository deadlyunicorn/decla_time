import 'package:flutter/material.dart';

List<Widget> listOfStringToListOfWidget(
  List<String> listOfString, {
  int countStart = 0,
}) {
  final widgetList = <Widget>[];

  for (int i = countStart; i < listOfString.length + countStart; i++) {
    widgetList.addAll([
      Text("${i + 1}. ${listOfString[i - countStart]}."),
      const SizedBox.square(dimension: 4),
    ]);
  }

  return widgetList;
}
