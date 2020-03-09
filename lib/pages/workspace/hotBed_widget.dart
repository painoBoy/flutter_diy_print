import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          // _operationPanel(),
          Container(
            width: ScreenUtil().setWidth(700),
            child: Slider(
              value: _progress,
              label: '$_progress',
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _progress = value.roundToDouble();
                });
              },
            ),
          ),
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
                      text: "${_progress.round()}°C",
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
    double _progress = 0;
    return Container(
        margin: EdgeInsets.all(20),
        width: ScreenUtil().width,
        height: ScreenUtil().setHeight(120),
        decoration: BoxDecoration(color: Colors.red),
        child: Column(
          children: <Widget>[
            // Container(
            //   alignment: Alignment.centerLeft,
            //   width: ScreenUtil().setWidth(450),
            //   // height: ScreenUtil().setHeight(60),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text("0"),
            //       Text("50"),
            //       Text("100"),
            //     ],
            //   ),
            // ),
            Container(
              alignment: Alignment.centerLeft,
              width: ScreenUtil().setWidth(450),
              height: 20,
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.only(left: ScreenUtil().setWidth(0)),
                  //   child: Image.asset("assets/images/workspace/line.png",width: ScreenUtil().setWidth(450),)
                  // )
                  Slider(
                    value: _progress,
                    label: '$_progress',
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        _progress = value.roundToDouble();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
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
