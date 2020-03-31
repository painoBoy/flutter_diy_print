import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/ScreenAdapter.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import '../../generated/i18n.dart';
import 'dart:ui';
import 'dart:io';

class PrinterInfoPage extends StatefulWidget {
  final Map arguments;
  PrinterInfoPage({Key key, this.arguments}) : super(key: key);
  @override
  _PrinterInfoPageState createState() => _PrinterInfoPageState();
}

class _PrinterInfoPageState extends State<PrinterInfoPage> {
  TextEditingController _controller = TextEditingController();

  _submit() async {
    if (widget.arguments["status"] == 0 || widget.arguments["status"] == 1) {
      if (Platform.isIOS) {
        await showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Are you sure you want to remove the Printer?',
                    style: TextStyle(fontSize: ScreenAdapter.size(30))),
                // content: Text('删除成功无法恢复'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop("0");
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    onPressed: () {
                      //解绑
                      unBundlePrinter();
                      Navigator.of(context).pop("1");
                    },
                  ),
                ],
              );
            });
      } else if (Platform.isAndroid) {
        await showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Are you sure you want to remove the Printer?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenAdapter.size(30)),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Deleting this part will permanently erase it.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop("0");
                    },
                  ),
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      //解绑
                      unBundlePrinter();
                      Navigator.of(context).pop("1");
                    },
                  ),
                ],
              );
            });
      }
    } else {
      showToast("打印机处于打印过程中,不能解绑");
      return;
    }
  }

  //解绑打印机
  unBundlePrinter() async{
    Map params = {
      "macAddress": widget.arguments["mac"],
    };
    var res = await NetRequest.post(Config.BASE_URL + unBundPrinter, data: params);
    if (res["code"] == 200) {
      showToast("解绑成功");
      Navigator.pop(context);
    }else{
      showToast(res["msg"]);
    }
  }

  _changeName() async {
    Map params = {
      "macAddress": widget.arguments["mac"],
      "customerName": _controller.text
    };
    var res = await NetRequest.post(Config.BASE_URL + editPrinterName, data: params);
    if (res["code"] == 200) {
      FocusScope.of(context).requestFocus(FocusNode());
      showToast("修改成功");
      Navigator.pop(context);
    }else{
      showToast(res["msg"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = widget.arguments["customerName"];
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("修改名称", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          GestureDetector(
              onTap: _submit,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("解绑",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.size(23))),
                ),
              )),
          GestureDetector(
              onTap: _changeName,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("修改名称",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.size(23))),
                ),
              )),
        ],
      ),
      body: Container(
        child: TextField(
          controller: _controller,
        ),
      ),
    );
  }
}
