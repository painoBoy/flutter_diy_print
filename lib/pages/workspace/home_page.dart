/*
 * @Author: your name
 * @Date: 2019-12-19 14:50:07
 * @LastEditTime: 2020-03-14 14:38:47
 * @LastEditors: Please set LastEditors
 * @Description: 打印首页
 * @FilePath: /diy_3d_print/lib/pages/home_page.dart
 */
import '../../utils/Storage.dart';
import '../../network/http_config.dart';
import './move_widget.dart';
import './hotBed_widget.dart';
import '../../pages/workspace/material_chenl.dart';
import '../../pages/workspace/nozzle.dart';
import '../../widget/popup_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../network/http_request.dart';
import 'dart:async';
import '../../network/api.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../provider/printerParams.dart';
import '../provider/printCommand.dart';

GlobalKey<_HomeState> childKey = GlobalKey();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _addKey = GlobalKey();
  var _barcode = "";
  bool isbindPirnt = false;
  List _printerList = []; //绑定用户打印机列表
  int _currentPrinterId; // 当前选中打印机id
  String _printerStatusText = "not connected";
  String _printerStatusIcon = "assets/images/workspace/green_icon.png";
  Timer _timer; //轮询查询打印机状态

  @override
  void initState() {
    super.initState();

    isBindPrint();
    getUserBidPrinter(); //获取用户绑定的打印机
    // initTimer();
  }

  initTimer() {
    _timer = new Timer.periodic(Duration(seconds: 10), (timer) {
      getPrinterInfo();
    });
  }

  cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  //获取用户绑定的打印机
  getUserBidPrinter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var res = await NetRequest.get(Config.BASE_URL + getUserPrint);
    print("打印机列表=====>${res}");
    if (res['code'] == 200) {
      if (res['data'].length != 0) {
        if (prefs.getInt("selectedPrintId") != null) {
          Provider.of<PrinterIdProvider>(context)
              .getPrinterId(prefs.getInt("selectedPrintId"));
          if (mounted)
            setState(() {
              _printerList = res['data'];
              _currentPrinterId =
                  prefs.getInt("selectedPrintId"); //初始化选择本地存储的已选择打印机Id
            });
        } else {
          //如果未选择过就默认索引为1的打印机id
          Provider.of<PrinterIdProvider>(context)
              .getPrinterId(res['data'][0]["id"]);
          prefs.setString(
              //如果未选择 就默认本地存储
              "printSize",
              res['data'][0]["parameter"]["motorStroke"]);
               prefs.setInt(
              //如果未选择 就默认存储List的第一个打印ID至本地
              "selectedPrintId",
              res['data'][0]["id"]);
          if (mounted)
            setState(() {
              _printerList = res['data'];
              _currentPrinterId = res['data'][0]["id"];
            });
        }

        getPrinterInfo();
      }
    }
  }

  //判断是否绑定打印机
  isBindPrint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("printMac") == null) {
      setState(() {
        isbindPirnt = false;
      });
    } else {
      loadPrintStatus();
      setState(() {
        isbindPirnt = true;
      });
    }
  }

  //获取打印机详情信息
  getPrinterInfo() async {
    print(Config.BASE_URL +
        printerInfo +
        "/${Provider.of<PrinterIdProvider>(context).printId}");
    var res = await NetRequest.get(Config.BASE_URL +
            printerInfo +
            "/${Provider.of<PrinterIdProvider>(context).printId}")
        .then((res) {
      print("res===${res}");
      if (res["code"] == 200) {
        switch (res["data"]["printState"]) {
          case 0:
            if (mounted) {
              setState(() {
                _printerStatusIcon =
                    "assets/images/workspace/unselect_icon.png";
                _printerStatusText = "not connected";
              });
            }
            break;
          case 1:
            if (mounted) {
              setState(() {
                _printerStatusIcon = "assets/images/workspace/green_icon.png";
                _printerStatusText = "connected";
              });
            }
            break;
          case 2:
            if (mounted) {
              setState(() {
                _printerStatusIcon = "assets/images/workspace/green_icon.png";
                _printerStatusText = "Printing in progress...";
              });
            }
            break;
          case 3:
            if (mounted) {
              setState(() {
                _printerStatusIcon = "assets/images/workspace/green_icon.png";
                _printerStatusText = "Printing...";
              });
            }
            break;
          case 4:
            if (mounted) {
              setState(() {
                _printerStatusIcon =
                    "assets/images/workspace/unselect_icon.png";
                _printerStatusText = "Temporarily stop Printing";
              });
            }
            break;
          default:
        }
      }
    });
  }

  //获取打印机状态
  loadPrintStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("请求获取打印机状态");
    var res = await NetRequest.get(
        Config.BASE_URL + getPrintStatus + "/${prefs.getString('printMac')}");
    print(res);
  }

  //想打印机发送命令
  // sendPrintCommand() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print(prefs.getString("userId"));
  //   Map params = {
  //     "userUUID": prefs.getString("userId"),
  //     "printerId": _currentPrinterId,
  //     "command": "M104 S${Provider.of<NozzleWarm>(context).nozzleWarm}"
  //   };
  //   var res =
  //       await NetRequest.post(Config.BASE_URL + sendCommand, data: params);
  //   print(res);
  // }

  //扫描二维码 绑定打印机
  Future _scan() async {
    Navigator.pop(context);
    print("进来了");
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this._barcode =
              'The user did not grant the camera permission!';
        });
      } else {
        setState(() {
          return this._barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() => this._barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this._barcode = 'Unknown error: $e');
    }
    if (_barcode.toString().split(":")[2].length == 30 &&
        _barcode.toString().split(":")[2] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Options options = Options(headers: {
        // HttpHeaders.acceptHeader: "accept: application/json;charset=UTF-8",
        "Cookie": "JSESSIONID=" + prefs.getString("JSESSIONID")
      });

      //绑定打印机
      var params = {
        "macAddress": _barcode.toString().split(":")[2],
        "customerName": "norman1"
      };
      var res =
          await Http.post(path: bindPrint, data: params, options: options);
      prefs.setString("printMac", _barcode.toString().split(":")[2]);
      print("用户绑定是${prefs.getString('JSESSIONID')}");
      if (prefs.getString("printMac") == null) {
        setState(() {
          isbindPirnt = false;
        });
      } else {
        setState(() {
          isbindPirnt = true;
        });
      }
      if (res["code"] == 200) {
        showToast(res["msg"] == "@@E2-20@@" ? "打印机添加成功！" : "");
        getUserBidPrinter();
      } else {
        showToast(res["msg"] == "@@E2-17@@" ? "您已经绑定过这台打印机" : "");
      }
    } else {
      print("无效二维码");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 获取屏幕宽度
    double screenHeight = MediaQuery.of(context).size.height; // 获取屏幕高度
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          // leading: Icon(
          //   Icons.folder,
          //   // color: Colors.white,
          // ),
          // backgroundColor: Colors.white,
          title: Text(
            "WorkSpace",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            //   child: Icon(Icons.add_circle,color: Colors.white,),
            // )
            IconButton(
                key: _addKey,
                onPressed: () {
                  _showAddMenu();
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ))
          ],
          elevation: 0,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: OKToast(
                position: ToastPosition.bottom,
                backgroundColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().width,
                      height: ScreenUtil().setHeight(450),
                      decoration: BoxDecoration(
                        color: Color(0xFFF79432),
                      ),
                      child: Stack(children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          width: ScreenUtil().setWidth(700),
                          height: ScreenUtil().setHeight(420),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: <Widget>[_banner(), _printStatus()],
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      width: screenWidth,
                      // height: ScreenUtil().setHeight(600),
                      child: TabBarPrint(),
                    ),
                  ],
                ))));
  }

  //打印机Banner
  Widget _banner() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          _printerStatusText == "Print..."
              ? LinearPercentIndicator(
                  width: ScreenUtil().setWidth(380),
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2500,
                  percent: 0.8,
                  center: Text(
                    "80.0%",
                    style: TextStyle(color: Colors.white),
                  ),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Color(0xFFF79432),
                )
              : Container(
                  width: ScreenUtil().setWidth(380),
                  height: 20,
                  color: Colors.white,
                ),
          Image.asset(
            "assets/images/workspace/banner_printer.png",
            width: ScreenUtil().setWidth(380),
            height: ScreenUtil().setHeight(300),
          )
        ],
      ),
    );
  }

  //打印机状态
  Widget _printStatus() {
    return Container(
      // color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFF79432),
            ),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
            padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            child: Text("Printer status",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Row(children: <Widget>[
            Image.asset(
              "$_printerStatusIcon",
              width: ScreenUtil().setWidth(35),
              height: ScreenUtil().setHeight(35),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(20),
            ),
            Text(
              _printerStatusText,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.grey[700], fontSize: ScreenAdapter.size(20)),
              overflow: TextOverflow.ellipsis,
            ),
          ])
        ],
      ),
    );
  }

  //选择打印机
  _selectPrinter(id, name, size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("selectedPrintId", id); // 本都存储当前选中PrinterId
    prefs.setString("printSize", size); // 本都存储Printer电机运动范围
    Provider.of<PrinterIdProvider>(context).getPrinterId(id);
    getPrinterInfo();

    if (mounted) {
      setState(() {
        _currentPrinterId = id;
      });
    }
    print("打印机id=${_currentPrinterId}");
    showToast("已选择${name}打印机", position: ToastPosition.top);
    Navigator.pop(context);
  }

  ///显示菜单
  _showAddMenu() {
    final RenderBox button = _addKey.currentContext.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    var a = button.localToGlobal(
        Offset(button.size.width - 8.0, button.size.height - 12.0),
        ancestor: overlay);
    var b = button.localToGlobal(button.size.bottomLeft(Offset(0, -12.0)),
        ancestor: overlay);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    showPopupWindow(
      context: context,
      fullWidth: true,
      isShowBg: true,
      position: position,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          // NavigatorUtils.goBack(context);
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    "assets/images/workspace/jt.png",
                  )),
            ),
            SizedBox(
              width: 120.0,
              height: 40.0,
              child: FlatButton.icon(
                  onPressed: _scan,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                  ),
                  icon: Icon(Icons.add_circle_outline),
                  label: Text(
                    "Add Printer",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.clip,
                  )),
            ),
            Container(width: 120.0, height: 0.6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.elliptical(5, 5)),
                // border: Border.all(
                //     color: Colors.grey, width: ScreenAdapter.width(1)),
              ),
              child: Column(
                  children: _printerList.map((value) {
                return _popMenuList(value);
              }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  //  pop打印机列表
  Widget _popMenuList(item) {
    return InkWell(
        onTap: () {
          _selectPrinter(item['id'], item['customerName'],
              item['parameter']['motorStroke']);
        },
        child: Container(
            width: 120.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.elliptical(5, 5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.print),
                Text(
                  "${item['customerName']}",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.left,
                ),
              ],
            )));
  }
}

//操作面板
class TabBarPrint extends StatefulWidget {
  @override
  _TabBarPrintState createState() => _TabBarPrintState();
}

class _TabBarPrintState extends State<TabBarPrint>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  double _progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: 4, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Container(
        height: ScreenAdapter.height(580),
        // color: Colors.red,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Color(0xFFF79432),
                    unselectedLabelColor: Colors.grey[600],
                    // indicatorPadding:EdgeInsets.only(bottom: 40),
                    //     EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                    // labelStyle: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.black),
                    // labelStyle: TextStyle(color: Color(0xFFF79432),fontSize: ScreenUtil().setSp(28)),
                    unselectedLabelStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: Colors.grey[600]),
                    indicatorColor: Color(0xFFF79432),
                    // indicator: UnderlineTabIndicator(
                    //   insets: EdgeInsets.symmetric(horizontal: 80)
                    // ),
                    // labelPadding: EdgeInsets.fromLTRB(20, ScreenUtil().setHeight(40), 0, ScreenUtil().setHeight(40)),
                    indicatorSize: TabBarIndicatorSize.label,
                    ////指示器大小的计算方式，TabBarIndicatorSize.tab：跟每个tab等宽，
                    tabs: <Widget>[
                      Container(
                        height: ScreenAdapter.height(200),
                        child: Tab(
                          icon: Image.asset(
                            "assets/images/workspace/warm_tab.png",
                            width: ScreenUtil().setWidth(100),
                            height: ScreenUtil().setHeight(90),
                          ),
                          text: "喷嘴温度",
                        ),
                      ),
                      Container(
                          height: ScreenAdapter.height(200),
                          child: Tab(
                            icon: Image.asset(
                              "assets/images/workspace/hotbed_tab.png",
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setHeight(90),
                            ),
                            text: "热床温度",
                          )),
                      Container(
                          height: ScreenAdapter.height(200),
                          child: Tab(
                            icon: Image.asset(
                              "assets/images/workspace/move_shaft_tab.png",
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setHeight(90),
                            ),
                            text: "移动轴",
                          )),
                      Container(
                          height: ScreenAdapter.height(200),
                          child: Tab(
                            icon: Image.asset(
                              "assets/images/workspace/material_tab.png",
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setHeight(90),
                            ),
                            text: "耗材",
                          )),
                    ],
                    controller: _controller,
                  ),
                )),
            Expanded(
              flex: 2,
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  NozzleWidget(), //喷嘴温度
                  HotBedWidget(), //热床温度
                  MoveWidget(), //移动轴
                  MaterialPanel(), //耗材
                ],
              ),
            )
          ],
        ));
  }
}
