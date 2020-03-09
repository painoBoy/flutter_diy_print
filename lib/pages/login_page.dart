import '../navigator.dart';
import '../network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../network/http_config.dart';
import '../network/http_request.dart';
import 'dart:convert';
// import 'package:jpush_flutter/jpush_flutter.dart';

import 'dart:async';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userPassController = TextEditingController();
  var _userNameController = TextEditingController();
  bool isConnected = false;
  String registrationId;
  int model = 1;
  List notificationList = [];
  bool isShowLoading = false;
  
  //登录app
  loginSys() { 
    if(mounted)setState(() {
      isShowLoading = true;
    });
    final params = {
      "loginType":0,
      "userName": _userPassController.text,
      "password":_userPassController.text,
    };
    //  HttpRequest.request(BASE_URL + login,method: "post",params: params).then((res) {
    //    print("res"+res);
    //    setState(() {
    //      isShowLoading = false;
    //       model = res.code;
    //    });
    // }).catchError((err) {
    //   print(err);
    // });

    Navigator.push(context, MaterialPageRoute(builder: (a) {
      return NavigatorBarPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // String local = WidgetsBinding.instance.window.locale.toString();
    print("local = ${WidgetsBinding.instance.window.locale}");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Column(
            children: <Widget>[
              Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil().setHeight(450),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF5591F), Color(0xFFFF8633)]),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      child: Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 30,
                      child: Text("$model",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    )
                  ],
                ),
              ),
              // LoginForm()
              Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(90)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenUtil.getInstance().setWidth(580),
                        height: ScreenUtil.getInstance().setHeight(85),
                        padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[350], blurRadius: 20)
                          ],
                        ),
                        child: TextField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                              hintText: "Account",
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.account_circle,
                                color: Colors.grey[500],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(55),
                      ),
                      Container(
                        width: ScreenUtil.getInstance().setWidth(580),
                        height: ScreenUtil.getInstance().setHeight(85),
                        padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                              ScreenUtil.getInstance().setSp(55))),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[350], blurRadius: 20)
                          ],
                        ),
                        child: TextField(
                          controller: _userPassController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "password",
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey[500],
                              )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        width: ScreenUtil.getInstance().setWidth(580),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text("Forgot Password ?",
                              style: TextStyle(
                                color: Color(0xFFFF8633),
                              )),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          loginSys(); // 点击登录按钮
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setSp(90)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFF5591F), Color(0xFFFF8633)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                ScreenUtil.getInstance().setSp(55))),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[350],
                                  blurRadius: ScreenUtil().setSp(25))
                            ],
                          ),
                          alignment: Alignment.center,
                          width: ScreenUtil.getInstance().setWidth(580),
                          height: ScreenUtil.getInstance().setHeight(85),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setSp(30)),
                        width: ScreenUtil().setWidth(500),
                        height: ScreenUtil().setHeight(90),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              IconData(0xe600, fontFamily: 'iconfont'),
                              size: ScreenUtil().setSp(70),
                            ),
                            Icon(
                              IconData(0xe603, fontFamily: 'iconfont'),
                              size: ScreenUtil().setSp(70),
                            ),
                            Icon(
                              IconData(0xe614, fontFamily: 'iconfont'),
                              size: ScreenUtil().setSp(70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Dont't have an account ?"),
                            Text(
                              " Register",
                              style: TextStyle(color: Color(0xFFFF8633)),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
          isShowLoading
              ? Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 30,
                  top: MediaQuery.of(context).size.height / 2 - 30,
                  child: SpinKitWave(
                    color: Color(0xFFF5591F),
                    size: 50,
                  ),
                )
              : Positioned(
                  child: Container(),
                )
        ]),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Form(
        key: _formKey, //设置globalKey，用于后面获取FormState
        autovalidate: true, //开启自动校验
        child: Column(
          children: <Widget>[
            TextFormField(
                autofocus: true,
                controller: _unameController,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名或邮箱",
                    icon: Icon(Icons.person)),
                // 校验用户名
                validator: (v) {
                  return v.trim().length > 0 ? null : "用户名不能为空";
                }),
            TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "您的登录密码",
                    icon: Icon(Icons.lock)),
                obscureText: true,
                //校验密码
                validator: (v) {
                  return v.trim().length > 5 ? null : "密码不能少于6位";
                }),
            // 登录按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("登录"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        //在这里不能通过此方式获取FormState，context不对
                        //print(Form.of(context));

                        // 通过_formKey.currentState 获取FormState后，
                        // 调用validate()方法校验用户名密码是否合法，校验
                        // 通过后再提交数据。
                        if ((_formKey.currentState as FormState).validate()) {
                          //验证通过提交数据
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
