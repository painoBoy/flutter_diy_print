import 'package:flutter/material.dart';

class PrinterIdProvider with ChangeNotifier {
  int _printerId; //printId
  int _printStatus = 0; //打印机状态
  Map _printerParams  = {
    "printState":0
  }; //打印机详情
  String _printTaskCode ; //打印任务Code
  int get printId => _printerId;
  int get printStatus => _printStatus;
  Map get printerParams => _printerParams;
  String get printTaskCode => _printTaskCode;
  void getPrinterId(id) {
    _printerId = id;
    notifyListeners();
  }

  void changePrinterParams(params) {
    _printerParams = params;
    notifyListeners();
  }
  //改变打印机任务code
  void changePrintTaskCode(str) {
    _printTaskCode = str;
    notifyListeners();
  }

  void changePrinterStatus(status) {
    _printStatus = status;
    notifyListeners();
  }
}
