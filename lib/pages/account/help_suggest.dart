import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';

class HelpSugPage extends StatelessWidget {
  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

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
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: ScreenAdapter.width(30)),
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenAdapter.size(33)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[_bodyContent()])),
    );
  }

  Widget _bodyContent() {
    return Column(
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
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 1,
            ))
      ],
    );
  }
}
