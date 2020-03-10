import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/nozzle.dart';

class HotBedWidget extends StatefulWidget {
  @override
  _HotBedWidgetState createState() => _HotBedWidgetState();
}

class _HotBedWidgetState extends State<HotBedWidget> {
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _operationPanelTilte(_progress), //
          _operationPanel(),
          _okBtn(),
        ],
      ),
    );
  }

  //操作面板 title
  Widget _operationPanelTilte(_progress) {
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
                text: "当前温度: ",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "${Provider.of<NozzleWarm>(context).hotBedWarm.round()}°C",
                      style: TextStyle(color: Color(0xFFF79432)))
                ]),
          ),
          Text("         "),
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
    return Container(
      child: Image.asset(
        "assets/images/workspace/okBtn.png",
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setHeight(100),
      ),
    );
  }
}
