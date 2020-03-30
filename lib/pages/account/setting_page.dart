import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import '../../generated/i18n.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Column(
                  children: <Widget>[
                    _bannerHeader(),
                    _catWidget(),
                    _optionList(),
                  ],
                ))));
  }

  Widget _bannerHeader() {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(ScreenAdapter.width(40),
                ScreenAdapter.width(30), ScreenAdapter.width(80), 0),
            width: ScreenAdapter.getScreenWidth(),
            height: ScreenAdapter.height(300),
            decoration: BoxDecoration(
              color: Color(0xFFF79432),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    radius: ScreenAdapter.size(80),
                    backgroundImage: AssetImage(
                        "assets/images/account/account_banner.jpeg")),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/userInfo").then((_) {
                      getUserInfo();
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin:
                              EdgeInsets.only(left: ScreenAdapter.width(30)),
                          child: Row(
                            children: <Widget>[
                              Text(
                                _userInfo == null ? "" : "${_userInfo['name']}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenAdapter.size(40)),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(left:ScreenAdapter.width(20)),
                                padding: EdgeInsets.fromLTRB(2, .5, 2, .5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:Border.all(width: 1, color: Colors.white),
                                ),
                                child: Text("编辑",style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.size(25)),),
                              )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: ScreenAdapter.width(30)),
                        child: Text(
                          _userInfo == null
                              ? ""
                              : "${S.of(context).app_account_phoneNum}: ${_userInfo['phoneNum']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenAdapter.size(25)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _catWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: ScreenAdapter.width(1), color: Colors.grey))),
      width: ScreenAdapter.getScreenWidth(),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/modelCollect");
                  },
                  child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: ScreenAdapter.width(1),
                                  color: Colors.grey))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            IconData(0xe610, fontFamily: 'iconfont'),
                            size: ScreenAdapter.size(70),
                          ),
                          Container(
                              padding: EdgeInsets.all(4),
                              child:
                                  Text("${S.of(context).app_account_favorite}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )))
                        ],
                      )))),
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/printHistory");
                  },
                  child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: ScreenAdapter.width(1))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            IconData(0xe64c, fontFamily: 'iconfont'),
                            size: ScreenAdapter.size(70),
                          ),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                  "${S.of(context).app_account_printHistory}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )))
                        ],
                      )))),
        ],
      ),
    );
  }

  Widget _optionList() {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(
              0, ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          padding: EdgeInsets.fromLTRB(10, 4, 5, 2),
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/printerManage");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        IconData(0xe630, fontFamily: 'iconfont'),
                        size: ScreenAdapter.size(50),
                        color: Colors.grey[600],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenAdapter.width(25)),
                        child: Text("${S.of(context).app_account_Management}"),
                      ),
                    ],
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: null),
                  )
                ],
              )),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
              0, ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          padding: EdgeInsets.fromLTRB(10, 4, 5, 2),
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/message");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(IconData(0xe641, fontFamily: 'iconfont'),
                          size: ScreenAdapter.size(50),
                          color: Color.fromRGBO(255, 105, 26, 1)),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenAdapter.width(25)),
                        child: Text("${S.of(context).app_account_message}"),
                      ),
                    ],
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: null),
                  )
                ],
              )),
        ),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/setting");
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  0, ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              padding: EdgeInsets.fromLTRB(10, 4, 5, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        IconData(0xe607, fontFamily: 'iconfont'),
                        size: ScreenAdapter.size(50),
                        // color: Color.fromRGBO(255, 105, 26, 1)
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenAdapter.width(25)),
                        child: Text("${S.of(context).app_account_setting}"),
                      ),
                    ],
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: null),
                  )
                ],
              ),
            )),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/help");
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
                0, ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            padding: EdgeInsets.fromLTRB(10, 4, 5, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(IconData(0xe696, fontFamily: 'iconfont'),
                        size: ScreenAdapter.size(50),
                        color: Color.fromRGBO(255, 105, 26, 1)),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenAdapter.width(25)),
                      child: Text("${S.of(context).app_account_help}"),
                    ),
                  ],
                ),
                Container(
                  child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_right), onPressed: null),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
