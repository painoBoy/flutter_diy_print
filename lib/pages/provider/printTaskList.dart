import 'package:flutter/material.dart';

class PrintTaskProvider with ChangeNotifier {
  List _taskList = [];
  List get taskList => _taskList;
  void getUserPrintTaskList(data) {
    _taskList.addAll(data);
    notifyListeners();
  }

  void clearUserPrintTaskList() {
    _taskList = [];
    notifyListeners();
  }
}
