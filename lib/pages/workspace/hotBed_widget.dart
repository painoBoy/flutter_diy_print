import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_diy_print/utils/ScreenAdapter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/printerParams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/printCommand.dart';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import '../../widget/hotBedWaveSlider.dart';

class HotBedWidget extends StatefulWidget {
  @override
  _HotBedWidgetState createState() => _HotBedWidgetState();
}

class _HotBedWidgetState extends State<HotBedWidget> {
  bool isShowLoading = false;
   //waveSlider 传值
  onDataChange(double val) {
     Provider.of<NozzleWarm>(context).changeHotBedWarm(val);
  }

  //设置热床温度
  _setPrinterHotBedWarm() async {
    if(mounted)setState(() {
      isShowLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userId"));
    Map params = {
      "userUUID": prefs.getString("userId"),
      "printerId": Provider.of<PrinterIdProvider>(context).printId,
      "command": "M140 S${Provider.of<NozzleWarm>(context).hotBedWarm}"
    };
    var res = await NetRequest.post(Config.BASE_URL + sendCommand, data: params);
    if(mounted)setState(() {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _operationPanelTitle(),
          HotBedSlider(callback1: (val) => onDataChange(val),callback2: (){_setPrinterHotBedWarm();}),
          // _operationPanel(),
          // _okBtn(),
          isShowLoading?CupertinoActivityIndicator():Text(""),
        ],
      ),
    );
  }

  //操作面板 title
  Widget _operationPanelTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "热床温度",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RichText(
            text: TextSpan(
                text: "设定温度: ",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${Provider.of<NozzleWarm>(context).hotBedWarm.round()}°C",
                      style: TextStyle(color: Color(0xFFF79432)))
                ]),
          ),
           RichText(
            text: TextSpan(
                text: "当前温度: ",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "0°C",
                      style: TextStyle(color: Color(0xFFF79432)))
                ]),
          ),
        ],
      ),
    );
  }

  //操作面板
  Widget _operationPanel() {
    return Container(
      width: ScreenUtil().setWidth(700),
      child: Slider(
        value: Provider.of<NozzleWarm>(context).hotBedWarm,
        label: '${Provider.of<NozzleWarm>(context).hotBedWarm}',
        min: 0,
        max: 100,
        onChanged: (value) {
          Provider.of<NozzleWarm>(context).changeHotBedWarm(value);
        },
      ),
    );
  }

  Widget _okBtn() {
    return GestureDetector(
      onTap: _setPrinterHotBedWarm,
      child: Container(
        child: Image.asset(
          "assets/images/workspace/okBtn.png",
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setHeight(100),
        ),
      ),
    );
  }
}
