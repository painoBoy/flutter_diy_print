import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _regType = 0; // 0:手机号码注册 1:邮箱注册
  Country _selected;
  Timer _timer;
  //倒计时数值
  int _countdownTime = 0;

  //倒计时方法
  _startCountdown() {
    _countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (_countdownTime < 1) {
          _timer.cancel();
        } else {
          _countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  var _userNameController = TextEditingController();
  var _passWordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();

  //页面关闭销毁timer
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusScopeNode());
          },
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/login_image/bg.png"),
                fit: BoxFit.cover,
              )),
            ),
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
                    alignment: Alignment.topCenter,
                    // margin: EdgeInsets.only(top: 120),
                    child: Image.asset(
                      "assets/images/login_image/logo.png",
                      width: 320,
                    )),
                _regType == 0
                    ?
                    //手机号码注册
                    Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                        width: ScreenUtil().setWidth(650),
                        height: ScreenUtil().setHeight(800),
                        decoration: BoxDecoration(
                            color: Color(0xFFFEFFFF),
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(40)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(blurRadius: 20, color: Colors.grey[400])
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(80)),
                                width: ScreenUtil.getInstance().setWidth(580),
                                height: ScreenUtil.getInstance().setHeight(85),
                                padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFFF4F5F6),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[350], blurRadius: 20)
                                  ],
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/register/phone_icon.png",
                                      width: ScreenUtil().setWidth(30),
                                    ),
                                    CountryPicker(
                                      showName: false,
                                      showDialingCode: true,
                                      onChanged: (Country country) {
                                        setState(() {
                                          _selected = country;
                                        });
                                        print("${country.dialingCode}");
                                      },
                                      selectedCountry: _selected,
                                    ),
                                    Container(
                                      width: ScreenUtil.getInstance()
                                          .setWidth(300),
                                      height: ScreenUtil.getInstance()
                                          .setHeight(85),
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Please enter your phone number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(30)),
                                  width: ScreenUtil.getInstance().setWidth(580),
                                  height:
                                      ScreenUtil.getInstance().setHeight(85),
                                  padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xFFF4F5F6),
                                    // boxShadow: [
                                    //   BoxShadow(color: Colors.grey[350], blurRadius: 20)
                                    // ],
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _userNameController,
                                    decoration: InputDecoration(
                                        hintText: "Verification code",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        border: InputBorder.none,
                                        icon: Image.asset(
                                          "assets/images/register/safe_icon.png",
                                          width: ScreenUtil().setWidth(35),
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: ScreenUtil().setWidth(20),
                                  child: InkWell(
                                      onTap: () {
                                        if (_countdownTime == 0) {
                                          _startCountdown();
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(180),
                                        height: ScreenUtil().setHeight(65),
                                        // padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFF79432),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _countdownTime > 0
                                              ? "${_countdownTime}s后重新获取"
                                              : "获取验证码",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Color(0xFFF79432)),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30)),
                              width: ScreenUtil.getInstance().setWidth(580),
                              height: ScreenUtil.getInstance().setHeight(85),
                              padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFF4F5F6),
                                // boxShadow: [
                                //   BoxShadow(color: Colors.grey[350], blurRadius: 20)
                                // ],
                              ),
                              child: TextField(
                                controller: _passWordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    hintText: "Please enter your Password",
                                    border: InputBorder.none,
                                    icon: Image.asset(
                                      "assets/images/login_image/password_icon.png",
                                      width: ScreenUtil().setWidth(35),
                                    )),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                print(_selected);
                                // loginSys(); // 点击登录按钮
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setSp(80)),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFF79432),
                                      Color(0xFFFFAD3C)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
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
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Container(
                                width: ScreenUtil.getInstance().setWidth(520),
                                height: ScreenUtil().setHeight(130),
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        _regType = 1;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Create Email Account",
                                    style: TextStyle(color: Color(0xFF2681FD)),
                                  ),
                                ))),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: ScreenUtil.getInstance().setWidth(520),
                                  alignment: Alignment.bottomRight,
                                  child: Text("have an account ?",
                                      style:
                                          TextStyle(color: Color(0xFFF79432))),
                                ))
                          ],
                        ),
                      )
                    :
                    //邮箱注册
                    Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                        width: ScreenUtil().setWidth(650),
                        height: ScreenUtil().setHeight(800),
                        decoration: BoxDecoration(
                            color: Color(0xFFFEFFFF),
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(40)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(blurRadius: 20, color: Colors.grey[400])
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30)),
                              width: ScreenUtil.getInstance().setWidth(580),
                              height: ScreenUtil.getInstance().setHeight(85),
                              padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFF4F5F6),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[350], blurRadius: 20)
                                ],
                              ),
                              child: TextField(
                                controller: _emailController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    hintText: "Please enter your E-Mail",
                                    border: InputBorder.none,
                                    icon: Image.asset(
                                      "assets/images/register/mail.png",
                                      width: ScreenUtil().setWidth(35),
                                    )),
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(30)),
                                  width: ScreenUtil.getInstance().setWidth(580),
                                  height:
                                      ScreenUtil.getInstance().setHeight(85),
                                  padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xFFF4F5F6),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[350],
                                          blurRadius: 20)
                                    ],
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _userNameController,
                                    decoration: InputDecoration(
                                        hintText: "Verification code",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        border: InputBorder.none,
                                        icon: Image.asset(
                                          "assets/images/register/safe_icon.png",
                                          width: ScreenUtil().setWidth(35),
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: ScreenUtil().setWidth(20),
                                  child: InkWell(
                                      onTap: () {
                                        if (_countdownTime == 0) {
                                          _startCountdown();
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(180),
                                        height: ScreenUtil().setHeight(65),
                                        // padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFF79432),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _countdownTime > 0
                                              ? "${_countdownTime}s后重新获取"
                                              : "获取验证码",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Color(0xFFF79432)),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30)),
                              width: ScreenUtil.getInstance().setWidth(580),
                              height: ScreenUtil.getInstance().setHeight(85),
                              padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFF4F5F6),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[350], blurRadius: 20)
                                ],
                              ),
                              child: TextField(
                                controller: _passWordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    hintText: "Please enter your Password",
                                    border: InputBorder.none,
                                    icon: Image.asset(
                                      "assets/images/login_image/password_icon.png",
                                      width: ScreenUtil().setWidth(35),
                                    )),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                print(_selected);
                                // loginSys(); // 点击登录按钮
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setSp(80)),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFF79432),
                                      Color(0xFFFFAD3C)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
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
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Container(
                                width: ScreenUtil.getInstance().setWidth(520),
                                height: ScreenUtil().setHeight(130),
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        _regType = 0;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Create Phone Account",
                                    style: TextStyle(color: Color(0xFF2681FD)),
                                  ),
                                ))),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: ScreenUtil.getInstance().setWidth(520),
                                  alignment: Alignment.bottomRight,
                                  child: Text("have an account ?",
                                      style:
                                          TextStyle(color: Color(0xFFF79432))),
                                ))
                          ],
                        ),
                      ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }
}
