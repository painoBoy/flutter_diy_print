import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:oktoast/oktoast.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';

class SexOptionPage extends StatefulWidget {
  @override
  _SexOptionPageState createState() => _SexOptionPageState();
}

class _SexOptionPageState extends State<SexOptionPage> {
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

  _changeSex(gender) async {
    String _sex = "0"; // 1:男性 非1:女性
    if (gender == Gender.Male) {
      _sex = "1";
    }
    
    Map params = {
      "avatar": "",
      "name": _userInfo["name"],
      "age": _userInfo["birth"],
      "sex": _sex,
      "area": "",
    };
    var res = await NetRequest.post(Config.BASE_URL + editUserInfo, data: params);
    if (res["code"] == 200) {
      _userInfo["sex"] = _sex;
      Storage.setString("userInfo", json.encode(_userInfo));
      showToast("修改成功");

      Navigator.pop(context);
    }
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
        title: Text("设置性别", style: TextStyle(color: Colors.white)),
      ),
      body: GenderSelection(
        maleText: "Male", //default Male
        femaleText: "FeMale", //default Female
        linearGradient: LinearGradient(
            colors: [const Color(0xFFFF5F6d), const Color(0xFFFFC371)],
            tileMode: TileMode.clamp,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.0, 1.0]),
        selectedGenderIconBackgroundColor: Color(0xFFF79432), // default red
        checkIconAlignment: Alignment.bottomCenter, // default bottomRight
        selectedGenderCheckIcon: Icons.done, // default Icons.check
        onChanged: (Gender gender) {
          _changeSex(gender);
        },
        equallyAligned: true,
        animationDuration: Duration(milliseconds: 400),
        isCircular: true, // default : true,
        isSelectedGenderIconCircular: true,
        opacityOfGradient: 0.6,
        padding: const EdgeInsets.all(3),
        size: 120, //default : 120
      ),
    );
  }
}
