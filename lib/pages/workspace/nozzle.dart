/*
 * @Author: liaozhou
 * @Date: 2020-01-18 13:37:23
 * @LastEditTime: 2020-03-12 17:07:41
 * @LastEditors: Please set LastEditors
 * @Description: 喷嘴温度操作面板widget
 * @FilePath: /diy_3d_print/lib/pages/workspace/nozzle.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import '../../network/api.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../provider/printerParams.dart';
import '../provider/printCommand.dart';

class NozzleWidget extends StatefulWidget {
  @override
  _NozzleWidgetState createState() => _NozzleWidgetState();
}

class _NozzleWidgetState extends State<NozzleWidget> {
  double _progress = 0;
  bool isShowLoading = false;

  //设置喷嘴温度
  _setPrinerNozzleWarm() async {
    if (mounted)
      setState(() {
        isShowLoading = true;
      });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userId"));
    Map params = {
      "userUUID": prefs.getString("userId"),
      "printerId": Provider.of<PrinterIdProvider>(context).printId,
      "command": "M104 S${Provider.of<NozzleWarm>(context).nozzleWarm}"
    };
    var res =
        await NetRequest.post(Config.BASE_URL + sendCommand, data: params);
    if (mounted)
      setState(() {
        isShowLoading = false;
      });
    if (res["code"] == 200) {
      showToast("Set up successfully",
          position: ToastPosition.bottom, backgroundColor: Colors.grey[400]);
    } else {
      showToast(res["msg"],
          position: ToastPosition.bottom, backgroundColor: Colors.grey[400]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _operationPanelTilte(), //title
          _operationPanel(), //热床操作面板
          _okBtn(),
          isShowLoading ? CupertinoActivityIndicator() : Text(""),
        ],
      ),
    );
  }

  //操作面板 title
  Widget _operationPanelTilte() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "喷嘴温度",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RichText(
            text: TextSpan(
                text: "当前温度: ",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${Provider.of<NozzleWarm>(context).nozzleWarm.round()}°C",
                      style: TextStyle(color: Color(0xFFF79432)))
                ]),
          ),
          Text("          ")
        ],
      ),
    );
  }

  //操作面板
  Widget _operationPanel() {
    return Container(
      width: ScreenUtil().setWidth(700),
      child: Slider(
        value: Provider.of<NozzleWarm>(context).nozzleWarm,
        label: '${Provider.of<NozzleWarm>(context).nozzleWarm}',
        min: 0,
        max: 100,
        onChanged: (value) {
          Provider.of<NozzleWarm>(context).changeNozzleWarm(value);
        },
      ),
    );
  }

  Widget _okBtn() {
    return Container(
      child: GestureDetector(
        onTap: _setPrinerNozzleWarm,
        child: Image.asset(
          "assets/images/workspace/okBtn.png",
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setHeight(100),
        ),
      ),
    );
  }
}
