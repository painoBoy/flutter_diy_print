import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NozzleWarm with ChangeNotifier {
  double _nozzleWarm = 0; // 喷嘴温度
  double _hotBed = 0; //热床温度
  int _direction = 0; //方向（x、y、z）
  int _pan; //正负
  int _distance = 5; //移动距离
  double _tempValue1 = 0; //喷嘴温度slider按钮移动定位temp值
  double _tempValue2 = 0; //热床温度slider按钮移动定位temp值
  double get nozzleWarm => _nozzleWarm;
  double get hotBedWarm => _hotBed;
  double get tempValue1 => _tempValue1;
  double get tempValue2 => _tempValue2;
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

  void changeTemValue1(val) {
    _tempValue1 = val;
    notifyListeners();
  }

  void changeTemValue2(val) {
    _tempValue2 = val;
    notifyListeners();
  }
}
