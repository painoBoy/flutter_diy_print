import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../../utils/ScreenAdapter.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import './sex_page.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map _userInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    var info = await Storage.getString("userInfo");
    if (mounted)
      setState(() {
        _userInfo = json.decode(info);
      });
  }

  _editBirth(date) async {
    if (date == "") {
      showToast("出生日期不能为空");
      return;
    }
    String birth = date.toString().substring(0, 10);
    Map params = {
      "avatar": "",
      "name": _userInfo["name"],
      "age": birth,
      "sex": _userInfo["sex"],
      "area": "",
    };

    var res =
        await NetRequest.post(Config.BASE_URL + editUserInfo, data: params);
    if (res["code"] == 200) {
      _userInfo["birth"] = birth;
      Storage.setString("userInfo", json.encode(_userInfo));
      showToast("修改成功");
      getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "${S.of(context).app_userInfo_title}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _user_options(),
    );
  }

  Widget _user_options() {
    return Container(
        child: ListView(
      children: <Widget>[
        Container(
          height: ScreenAdapter.height(90),
          padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("昵称"),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/setUserInfo").then((_) {
                    getUserInfo();
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text("${_userInfo["name"]}"),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(),
        Container(
          height: ScreenAdapter.height(90),
          padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(40)),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/setUserSex").then((_) {
                getUserInfo();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("性别"),
                Row(
                  children: <Widget>[
                    Text(_userInfo["sex"] == "0" ? "女" : "男"),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(),
        Container(
          height: ScreenAdapter.height(90),
          padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("出生日期"),
              GestureDetector(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 3, 5),
                        maxTime: DateTime.now(), onConfirm: (date) {
                      _editBirth(date);
                    }, currentTime: DateTime.now(), locale: LocaleType.zh);
                  },
                  child: Row(
                    children: <Widget>[
                      Text("${_userInfo["birth"]}"),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ))
            ],
          ),
        ),
        Divider(),
      ],
    ));
  }
}
