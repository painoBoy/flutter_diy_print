import 'package:flutter/material.dart';

class PrinterIdProvider with ChangeNotifier {
  int _printerId; //printId
  int _printStatus = 0; //打印机状态
  int _printTaskStatus = 0; // 0 没有打印任务 1 有打印任务
  Map _printerParams  = {
    "printState":0,
    "printProgress":0,
    "boardTmp":0,//热床当前温度
    "targetBoardTmp":0,
    "endTmp":0,//喷头当前温度
  }; //打印机详情
  Map _printTaskDetail = {

  };
  String _printTaskCode ; //打印任务Code
  int get printId => _printerId;
  int get printStatus => _printStatus;
  int get printTaskStatus => _printTaskStatus;
  Map get printerParams => _printerParams;
  Map get printTaskDetail => _printTaskDetail;
  String get printTaskCode => _printTaskCode;
  void getPrinterId(id) {
    _printerId = id;
    notifyListeners();
  }

  void changePrinterParams(params) {
    _printerParams = params;
    notifyListeners();
  }

 void changePrintTaskDetail(params) {
    _printTaskDetail = params;
    notifyListeners();
  }

  void changePrinterTaskStatus(params) {
    _printTaskStatus = params;
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
