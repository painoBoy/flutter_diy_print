import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import '../../utils/Storage.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  bool isShowLoading = false;
  var _userNameController = TextEditingController();
  var _passWordController = TextEditingController();

  //登录
  loginSys() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isShowLoading = true;
    });
    var params = {
      "loginType": 0,
      "username": _userNameController.text.trim(),
      "password": _passWordController.text.trim()
    };
    // HttpRequest.request(BASE_URL + login, method: "post", params: params)
    //     .then((res) {
    //   print(params);
    //   print(res.data.toString());
    //   print(BASE_URL + login);

    //   setState(() {
    //     isShowLoading = false;
    //   });
    //   // Navigator.pushReplacementNamed(context, "/tabs");
    // });
    var dio = Dio();
    Response response = await dio.post(Config.BASE_URL + login, data: params);
    // // print(response.headers["set-cookie"].toString().split(";linshu")[0].split("=")[1]);
    // var response = await HttpRequest.post(Config.BASE_URL +login,params: params);
    if (response != null) {
      if (mounted)
        setState(() {
          isShowLoading = false;
        });
      if (response.data["code"] == 200) {
        Storage.setString("userId", response.data["data"]["userId"]);
        Storage.setString(
            "JSESSIONID",
            response.headers["set-cookie"]
                .toString()
                .split(";")[0]
                .split("=")[1]);
        Storage.setString("userInfo", json.encode(response.data["data"]));

        print(response.data["data"].toString());
        Navigator.pushReplacementNamed(context, "/tabs");
      } else {
        print(response.data["msg"]);
        showToast(response.data["msg"]);
      }
      // Navigator.pushNamedAndRemoveUntil(context, "/tabs" , ModalRoute.withName('/'));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: OKToast(
        position: ToastPosition.bottom,
        backgroundColor: Colors.grey[600],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent, // 输入框弹出时点击其他区域关闭输入框
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
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
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
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                          width: ScreenUtil.getInstance().setWidth(580),
                          height: ScreenUtil.getInstance().setHeight(85),
                          padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFF4F5F6),
                          ),
                          child: TextField(
                            maxLength: 20,
                            controller: _userNameController,
                            decoration: InputDecoration(
                                counterText: "",
                                hintText: "Please Enter you Account",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey[500],
                                )),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                          width: ScreenUtil.getInstance().setWidth(580),
                          height: ScreenUtil.getInstance().setHeight(85),
                          padding: EdgeInsets.fromLTRB(18, 2, 0, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFF4F5F6),
                          ),
                          child: TextField(
                            maxLength: 20,
                            controller: _passWordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                counterText: "",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                hintText: "Please Enter you Password",
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey[500],
                                )),
                          ),
                        ),
                        // CountryPicker(
                        //   showDialingCode: true,
                        //   onChanged: (Country country) {
                        //     setState(() {
                        //       _selected = country;
                        //     });
                        //   },
                        //   selectedCountry: _selected,
                        // ),
                        FlatButton(
                            onPressed: () {
                              loginSys();
                            },
                            // 点击登录按钮
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: ScreenUtil().setSp(60)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFF79432),
                                    Color(0xFFFFAD3C)
                                  ],
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
                            )),
                        // ),
                        SizedBox(
                          height: ScreenUtil().setHeight(70),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().setWidth(560),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "register");
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Color(0xFFF79432),
                                      fontSize: ScreenUtil().setSp(28)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/forgotpassword");
                                },
                                child: Text("Forgot Password?",
                                    style: TextStyle(
                                        color: Color(0xFF2681FD),
                                        fontSize: ScreenUtil().setSp(28))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0,
                              ScreenUtil().setHeight(40),
                              0,
                              ScreenUtil().setHeight(40)),
                          width: ScreenUtil.getInstance().setWidth(580),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(195),
                                height: ScreenUtil().setHeight(3),
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                              ),
                              Text(
                                "Or",
                                style: TextStyle(color: Color(0xFF9aacbd)),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: ScreenUtil().setHeight(3),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().setWidth(520),
                          height: ScreenUtil().setHeight(130),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/login_image/google_icon.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text("Google")
                                  ],
                                ),
                              ),
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/login_image/twitter_icon.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Twitter")
                                ],
                              )),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/login_image/facebook_icon.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text("Facebook")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isShowLoading
                  ? Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      top: MediaQuery.of(context).size.height / 2 - 30,
                      child: SpinKitWave(
                        color: Color(0xFFF79432),
                        size: 40.0,
                      ),
                    )
                  : Text(""),
            ]),
          ),
        ),
      ),
    );
  }
}
