import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NozzleWarm with ChangeNotifier {
  double _nozzleWarm = 0 ;// 喷嘴温度
  double _hotBed = 0 ;//热床温度
  double get nozzleWarm => _nozzleWarm;
  double get hotBedWarm => _hotBed;
  void changeNozzleWarm(warm){
    _nozzleWarm = warm;
    notifyListeners();

  }
   void changeHotBedWarm(warm){
    _hotBed = warm;
    notifyListeners();
  }
}