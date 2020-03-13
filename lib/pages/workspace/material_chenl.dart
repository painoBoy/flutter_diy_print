/*
 * @Author: your name
 * @Date: 2020-01-18 15:16:33
 * @LastEditTime: 2020-03-13 23:11:39
 * @LastEditors: Please set LastEditors
 * @Description: 耗材操作面板
 * @FilePath: /diy_3d_print/lib/pages/workspace/material_chenl.dart
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../provider/printCommand.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'dart:io';

//进退料
class MaterialPanel extends StatefulWidget {
  @override
  _MaterialPanelState createState() => _MaterialPanelState();
}

class _MaterialPanelState extends State<MaterialPanel> {
  bool isShowLoading = false;

  _materialIn(context, type) async {
    if (type == 0) {
      //0 进料 1 退料
      if (Platform.isIOS) {
        var res = await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('确定要向打印机进料吗?'),
              content: Text('进料期间喷嘴将自动加热,请耐心等待'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop("0");
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    materailIn();
                    Navigator.of(context).pop("1");
                  },
                ),
              ],
            );
          },
        );
      } else if (Platform.isAndroid) {
        var res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "确定要向打印机进料吗?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('进料期间喷嘴将自动加热,请耐心等待.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop("0");
                    },
                  ),
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      materailIn();
                      Navigator.of(context).pop("1");
                    },
                  ),
                ],
              );
            });
      }
    } else {
      if (Platform.isIOS) {
        print("退料");
        var res = await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('确定打印机退料吗?'),
              content: Text('退料期间喷嘴将自动加热,请耐心等待'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop("0");
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    materailOut();
                    Navigator.of(context).pop("1");
                  },
                ),
              ],
            );
          },
        );
      } else if (Platform.isAndroid) {
        var res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "确定要向打印机退料吗?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('退料期间喷嘴将自动加热,请耐心等待.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop("0");
                    },
                  ),
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      materailOut();
                      Navigator.of(context).pop("1");
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  //打印机出料
  materailOut() async {
    if (mounted)
      setState(() {
        isShowLoading = true;
      });
    Map params = {
      "enderIds": [0],
      "printerId": Provider.of<PrinterIdProvider>(context).printId
    };
    var res = await NetRequest.post(Config.BASE_URL + pullOut, data: params);
    if (mounted)
      setState(() {
        isShowLoading = false;
      });
    if (res["code"] == 200) {
      print(res);
      showToast("Successful operation",
          position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
    } else {
      showToast(res["msg"],
          position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
    }
  }

  //打印机进料
  materailIn() async {
    if (mounted)
      setState(() {
        isShowLoading = true;
      });
    Map params = {
      "enderIds": [0],
      "printerId": Provider.of<PrinterIdProvider>(context).printId
    };
    var res = await NetRequest.post(Config.BASE_URL + pullIn, data: params);
    if (mounted)
      setState(() {
        isShowLoading = false;
      });
    if (res["code"] == 200) {
      print(res);
      showToast("Successful operation",
          position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
    } else {
      showToast(res["msg"],
          position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 15, 5, 10),
      width: ScreenUtil().width,
      child: isShowLoading
          ? Stack(
              children: <Widget>[
                Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _item("进料", "assets/images/workspace/material_in.png",
                            context, 0),
                        _item("退料", "assets/images/workspace/material_out.png",
                            context, 1),
                      ],
                    )),
                // Positioned(
                //   left: ScreenUtil().width / 2 ,
                //   top:50,
                //   child: CupertinoActivityIndicator())
                Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 2 - 15, 50, 0, 0),
                  child: CupertinoActivityIndicator(),
                )
              ],
            )
          : Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _item("进料", "assets/images/workspace/material_in.png",
                      context, 0),
                  _item("退料", "assets/images/workspace/material_out.png",
                      context, 1),
                ],
              )),
    );
  }

  //进料 退料btn
  Widget _item(
    String name,
    String url,
    BuildContext context,
    int type,
  ) {
    return Material(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: ScreenUtil().setWidth(220),
          height: ScreenUtil().setWidth(220),
          child: InkWell(
            onTap: () {
              _materialIn(context, type);
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.grey[800]),
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(330)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("$name"),
                    Image.asset(
                      url,
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setHeight(120),
                    ),
                  ],
                )),
          )),
    );
  }
}
