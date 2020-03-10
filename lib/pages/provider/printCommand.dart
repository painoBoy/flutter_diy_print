import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrinterIdProvider with ChangeNotifier {
  int _printerId; //printId
  int get printId => _printerId;
  void getPrinterId(id) {
    _printerId = id;
    notifyListeners();
  }
}
