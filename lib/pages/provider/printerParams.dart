import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NozzleWarm with ChangeNotifier {
  double _nozzleWarm = 0; // 喷嘴温度
  double _hotBed = 0; //热床温度
  int _direction = 0; //方向（x、y、z）
  int _pan; //正负
  int _distance = 5; //移动距离
  double get nozzleWarm => _nozzleWarm;
  double get hotBedWarm => _hotBed;
  int get direction => _direction;
  int get distance => _distance;
  int get pan => _pan;
  void changeNozzleWarm(warm) {
    //改变喷嘴温度
    _nozzleWarm = warm;
    notifyListeners();
  }

  void changeHotBedWarm(warm) {
    //改变热床温度
    _hotBed = warm;
    notifyListeners();
  }

  void changeDirection() {
    //改变轴
    if (_direction == 2) {
      _direction = 0;
    } else {
      _direction++;
    }
    print(_direction);
    notifyListeners();
  }

  void changePan(size) {
    //改变正负
    _pan = size;
    notifyListeners();
  }

  void changeDistance() {
    //改变距离
    _distance == 5 ? _distance = 10 : _distance = 5;
    notifyListeners();
  }
}
