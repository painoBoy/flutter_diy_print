import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:oktoast/oktoast.dart';
import '../../network/api.dart';
import '../../generated/i18n.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import '../../widget/loading.dart';


class HelpSugPage extends StatefulWidget {
  @override
  _HelpSugPageState createState() => _HelpSugPageState();
}

class _HelpSugPageState extends State<HelpSugPage> {
   TextEditingController _feedbackController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  bool _isLoading = false;

  _submit(context) async{

    if(_feedbackController.text == ""){
      showToast("请填入具体详情");
      return ;
    }

    if(_mailController.text == ""){
      showToast("请填入联系方式");
      return ;
    }
    if(mounted)setState(() {
      _isLoading  = true;
    });
    Map params = {
      "description":_feedbackController.text,
      "contact":_mailController.text,
      "imgUrl":"",
    };
    var res = await NetRequest.post(Config.BASE_URL + feedback, data: params);
    if(mounted)setState(() {
      _isLoading  = true;
    });
    if(res["code"] == 200){
      FocusScope.of(context).requestFocus(FocusNode());
      showToast("提交成功,非常感谢您的反馈！");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          "Help & FeedBack",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){_submit(context);},
            child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: ScreenAdapter.width(30)),
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenAdapter.size(33)),
            ),
          ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[_bodyContent()])),
    );
  }

  Widget _bodyContent() {
    return ProgressDialog(
      msg:'',
      loading: _isLoading,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
              width: ScreenAdapter.getScreenWidth(),
              decoration: BoxDecoration(
                  // color: Colors.white,
                  ),
              child: Text("feedback", style: TextStyle(color: Colors.grey[400]))),
          Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: "Describe your issue or share you ideas",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: TextStyle(color: Colors.grey[600]),
                maxLength: 140,
                maxLines: 10,
              )),
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: _mailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: "Please enter your phone or Email",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.grey[600]),
                maxLines: 1,
              ))
        ],
      )
    );
  }
}