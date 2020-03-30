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
  List _userFavoriteModelList;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    print("_userFavoriteModelList = $_userFavoriteModelList");
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
            body: _userFavoriteModelList == null
                ? loadItem()
                : ListView(
                    children: _userFavoriteModelList.map((val) {
                    return _item(val);
                  }).toList())));
  }

  Widget loadItem() {
    return Container(
      width: ScreenAdapter.getScreenWidth(),
      height: ScreenAdapter.height(150),
      padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: ScreenAdapter.width(220),
                height: ScreenAdapter.height(140),
                color: Colors.grey[400]),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: ScreenAdapter.width(160),
                  height: ScreenAdapter.height(40),
                  color: Colors.grey[400],
                ),
                SizedBox(height: 5),
                Container(
                  width: ScreenAdapter.width(240),
                  height: ScreenAdapter.height(40),
                  color: Colors.grey[400],
                ),
              ],
            ),
            Text("")
          ],
        ),
      ),
    );
  }

  Widget _item(val) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/modelDetail",
              arguments: {"objId": val["id"]});
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: ScreenAdapter.width(220),
                height: ScreenAdapter.height(140),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: '${val["icon"]}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "${val["name"]}",
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(28),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Favorite date: ${val["collectionTime"]}",
                      style: TextStyle(fontSize: ScreenAdapter.size(25)),
                    ),
                  ),
                ],
              ),
              Text("")
            ],
          ),
        ),
      ),
    );
  }
}
