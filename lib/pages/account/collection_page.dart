/*
 * @Author: your name
 * @Date: 2020-03-02 15:21:39
 * @LastEditTime: 2020-03-06 15:21:41
 * @LastEditors: Please set LastEditors
 * @Description: 模型收藏页面
 * @FilePath: /diy_3d_print/lib/pages/account/collection_page.dart
 */

import '../../utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/services.dart';
import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'package:dio/dio.dart';

class ModelCollectionPage extends StatefulWidget {
  @override
  _ModelCollectionPageState createState() => _ModelCollectionPageState();
}

class _ModelCollectionPageState extends State<ModelCollectionPage> {
  List _userFavoriteModelList = [];
  List _modelList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserFavoriteModels();
  }

  _getUserFavoriteModels() async {
    var res = await NetRequest.get(Config.BASE_URL + favoriteList);
    print("res=${res}");
    if (res["data"] != null) {
      if (mounted)
        setState(() {
          _userFavoriteModelList = res["data"];
        });
      // for (int i = 0; i < _userFavoriteModelList.length; i++) {
      //   Response response = await Dio().get(
      //       "https://www.myminifactory.com/api/v2/objects/${_userFavoriteModelList[i]}?page=1&per_page=8&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      //   print(response.data[i]["name"]);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.white, size: ScreenAdapter.size(80)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              brightness: Brightness.light,
              title: Text(
                "Model Collection",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ListView(
              children: <Widget>[
                _collectList(),
              ],
            )));
  }

  Widget _collectList() {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: ScreenAdapter.width(220),
              height: ScreenAdapter.height(140),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    'https://cdn.myminifactory.com/assets/object-assets/5c2cda23b1faf/images/230X230-p1060757.JPG',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text("wiget's name",
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(40),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  child: Text("收藏日期: 2018-12-03"),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
              width: ScreenAdapter.width(155),
              alignment: Alignment.center,
              height: ScreenAdapter.height(55),
              decoration: BoxDecoration(
                  color: Color(0xFFF79432),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Print",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenAdapter.size(35)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
