import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../provider/printerParams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/printCommand.dart';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../widget/loading.dart';
import '../../network/http_request.dart';

class MoveWidget extends StatefulWidget {
  @override
  _MoveWidgetState createState() => _MoveWidgetState();
}

class _MoveWidgetState extends State<MoveWidget>
    with SingleTickerProviderStateMixin {
  List _direction = ["X", "Y", "Z"]; //x、y、z轴
  int _directionIndex = 0;
  bool isShowLoading = false;
  // int _distance = 5;
  double _iconSize = 100;
  //切换轴
  changeDirection() {
    Provider.of<NozzleWarm>(context).changeDirection();
  }

  //切换距离
  changeDistance() {
    Provider.of<NozzleWarm>(context).changeDistance();
  }

  // 设置打印机
  // type: 1.操作轴+ ; 2.操作轴- ; 3.复位
  setPrinter(type) async {
    String _setType;
    if (type == 1) {
      _setType =
          "G91\r\nG1 ${_direction[Provider.of<NozzleWarm>(context).direction]}+${Provider.of<NozzleWarm>(context).distance}\r\nG90";
    } else if (type == 2) {
      _setType =
          "G91\r\nG1 ${_direction[Provider.of<NozzleWarm>(context).direction]}-${Provider.of<NozzleWarm>(context).distance}\r\nG90";
    } else if (type == 3) {
      _setType = "G28";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userId"));
    Map params = {
      "userUUID": prefs.getString("userId"),
      "printerId": Provider.of<PrinterIdProvider>(context).printId,
      "command": _setType
    };
    if (Provider.of<PrinterIdProvider>(context).printId != null) {
      if (mounted)
        setState(() {
          isShowLoading = true;
        });
      //是否选择了打印机
      var res =
          await NetRequest.post(Config.BASE_URL + sendCommand, data: params);
      print(res);
      if (mounted)
        setState(() {
          isShowLoading = false;
        });
      if (res["code"] == 200) {
        showToast("SET OK",
            position: ToastPosition.bottom, backgroundColor: Colors.grey[400]);
      } else {
        showToast(res["msg"],
            position: ToastPosition.bottom, backgroundColor: Colors.grey[400]);
      }
    } else {
      showToast("please bind the printer",
          position: ToastPosition.bottom, backgroundColor: Colors.green[400]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
        loading: isShowLoading,
        msg: 'Setting up...',
        child: Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(
                0, ScreenAdapter.height(40), 0, ScreenAdapter.height(40)),
            margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: (){setPrinter(1);},
                            child: Icon(
                              Icons.add_circle_outline,
                              size: ScreenAdapter.size(100),
                            ),
                          ),
                          InkWell(
                              onTap: (){setPrinter(2);},
                              child: Icon(Icons.remove_circle_outline,
                                  size: ScreenAdapter.size(100))),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("移动轴"),
                          Container(
                            width: ScreenAdapter.width(200),
                            height: ScreenAdapter.width(200),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenAdapter.width(200)),
                                border: Border.all(
                                  width: ScreenAdapter.width(4),
                                  color: Colors.black,
                                )),
                            child: InkWell(
                              onTap: changeDirection,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${_direction[Provider.of<NozzleWarm>(context).direction]}",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(50),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      Provider.of<NozzleWarm>(context)
                                                  .direction ==
                                              2
                                          ? "点击切换X轴"
                                          : "点击切换${_direction[Provider.of<NozzleWarm>(context).direction + 1]}轴",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(15),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          )
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Icon(Icons.filter_list, size: ScreenAdapter.size(80)),
                          Container(
                            width: ScreenAdapter.width(90),
                            height: ScreenAdapter.width(90),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenAdapter.width(90)),
                                border: Border.all(
                                  width: ScreenAdapter.width(5),
                                  color: Colors.black,
                                )),
                            child: InkWell(
                              onTap: changeDistance,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${Provider.of<NozzleWarm>(context).distance}mm",
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(18),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ),
                          GestureDetector(
                              onTap: (){setPrinter(3);},
                              child: Icon(Icons.refresh,
                                  size: ScreenAdapter.size(100))),
                        ]),
                  ],
                ),
              ],
            )));
  }
}
