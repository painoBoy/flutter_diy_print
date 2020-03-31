import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import '../../generated/i18n.dart';

class PrinterManage extends StatefulWidget {
  @override
  _PrinterManageState createState() => _PrinterManageState();
}

class _PrinterManageState extends State<PrinterManage> {
  List _printerList = [];
  bool _isLoading ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userBindPrinter();
  }

  _userBindPrinter() async {
    var res = await NetRequest.get(Config.BASE_URL + getUserPrint);
    print("Res = $res");
      _isLoading= false;

    if (res["code"] == 200) {
      setState(() {
        _printerList = res["data"];
      });
    } else {
      showToast(res["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: ScreenAdapter.size(80),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text("${S.of(context).app_printerMan_title}",
              style: TextStyle(color: Colors.white)),
        ),
        body:
         _isLoading == null
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : _printerList.length == 0?Center(
                child: Text("没有数据"),
              ) : ListView(
                children: _printerList.map((val) {
                return _item(val);
              }).toList()));
  }

  Widget _item(val) {
    return GestureDetector(
      onTap:(){Navigator.pushNamed(context, "/printerInfo",arguments: val).then((_){_userBindPrinter();});},
      child: Card(
        child: Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenAdapter.width(20)),
              width: ScreenAdapter.width(200),
              height: ScreenAdapter.height(200),
              child: Image.asset(
                "assets/images/workspace/banner_printer.png",
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenAdapter.width(60)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${S.of(context).app_printerMan_name}:",
                          style: TextStyle(
                              fontSize: ScreenAdapter.size(28),
                              color: Colors.grey[700]),
                        ),
                      ),
                      Text("${val["customerName"]}")
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenAdapter.width(60)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${S.of(context).app_printerMan_status}:",
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(28),
                                color: Colors.grey[700])),
                        Text("${val["status"]}")
                      ],
                    )),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenAdapter.width(60)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${S.of(context).app_printerMan_name}:",
                          style: TextStyle(
                              fontSize: ScreenAdapter.size(28),
                              color: Colors.grey[700]),
                        ),
                      ),
                      Text("${val["batch"]}")
                    ],
                  ),
                )
              ],
            )),
          ],
        )),
      ),
    );
  }
}
