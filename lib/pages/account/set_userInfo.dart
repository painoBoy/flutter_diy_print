import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';
import '../../utils/Storage.dart';
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';

class SetUserInfoPage extends StatefulWidget {
  @override
  _SetUserInfoPageState createState() => _SetUserInfoPageState();
}

class _SetUserInfoPageState extends State<SetUserInfoPage> {
  TextEditingController _controller = TextEditingController();
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
      _controller.text = _userInfo["name"];
  }

  //修改名称
  _submit() async{
    if(_controller.text == ""){
      showToast("名称不能为空");
      return;
    }
    Map params = {
      "avatar":"",
      "name":_controller.text,
      "age":_userInfo["birth"],
      "sex":_userInfo["sex"],
      "area":"",
    };

    var res = await NetRequest.post(Config.BASE_URL + editUserInfo, data: params);
    if(res["code"]== 200){
      _userInfo["name"] = _controller.text;
      Storage.setString("userInfo", json.encode(_userInfo));
      _controller.text = "";
      showToast("修改成功");

      Navigator.pop(context);
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
        title: Text("设置昵称",style: TextStyle(color:Colors.white)),
        actions: <Widget>[
          GestureDetector(
            onTap:_submit,
            child:Center(child: Padding(padding:EdgeInsets.only(right: 10),child: Text("完成",style: TextStyle(color:Colors.white)),),)
          )
        ],
      ),
      body:Container(
        child: TextField(
          controller: _controller,
        ),
      ),
    );
  }
}
