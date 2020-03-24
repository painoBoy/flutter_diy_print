import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/ScreenAdapter.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:io';

class AccountSettingPage extends StatefulWidget {
  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: ScreenAdapter.size(80),
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Setting",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          _generalWdiget(),
        ],
      ),
    );
  }

  //退出登录
  _signOut() async {
    if (Platform.isIOS) {
      await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Are you sure you want to log out ?'),
              content: Text(''),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop("0");
                  },
                ),
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () async{
                    var res = await NetRequest.get(Config.BASE_URL + logout);
                    if (res["code"] == 200) {
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                       prefs.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            );
          },
        );
    } else if (Platform.isAndroid) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Are you sure you want to log out ?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(''),
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
                  child: Text('OK'),
                  onPressed: () async {
                    var res = await NetRequest.get(Config.BASE_URL + logout);
                    if (res["code"] == 200) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    }else{
                      showToast(res["msg"],position: ToastPosition.bottom,backgroundColor: Colors.grey[400]);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  //通用设置
  Widget _generalWdiget() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
            width: ScreenAdapter.getScreenWidth(),
            decoration: BoxDecoration(
                // color: Colors.white,
                ),
            child: Text("General", style: TextStyle(color: Colors.grey[400]))),
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Container(
                child: ListTile(
                  title: Text('Notification'),
                  trailing: CupertinoSwitch(
                    value: _lights,
                    onChanged: (bool value) {
                      setState(() {
                        _lights = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _lights = !_lights;
                    });
                  },
                ),
              ),
              Divider(),
              Container(
                child: ListTile(
                    onTap: () {},
                    title: Text('Clear Cache'),
                    trailing: Icon(Icons.keyboard_arrow_right)),
              ),
              Divider(),
              Container(
                child: ListTile(
                    onTap: () {},
                    title: Text('About'),
                    trailing: Icon(Icons.keyboard_arrow_right)),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
            width: ScreenAdapter.getScreenWidth(),
            decoration: BoxDecoration(
                // color: Colors.white,
                ),
            child: Text("Account", style: TextStyle(color: Colors.grey[400]))),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // boxShadow: <BoxShadow>[
            //   BoxShadow(blurRadius: 1, color: Colors.grey[400])
            // ]
          ),
          width: ScreenAdapter.getScreenWidth(),
          height: ScreenAdapter.height(180),
          child: InkWell(
              onTap: _signOut,
              child: Center(
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                      color: Color.fromRGBO(179, 55, 66, 1),
                      fontSize: ScreenAdapter.size(40)),
                ),
              )),
        )
      ],
    );
  }
}
