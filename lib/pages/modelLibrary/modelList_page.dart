/*
 * @Author: your name
 * @Date: 2020-02-25 16:36:29
 * @LastEditTime: 2020-03-02 11:12:11
 * @LastEditors: Please set LastEditors
 * @Description: 模型类型more列表页
 * @FilePath: /diy_3d_print/lib/pages/modelLibrary/modelList_page.dart
 */

import '../../utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/services.dart';

class ModelListPage extends StatefulWidget {
  final Map arguments;
  ModelListPage({Key key, this.arguments}) : super(key: key);
  @override
  _ModelListPageState createState() => _ModelListPageState();
}

class _ModelListPageState extends State<ModelListPage> {
  EasyRefreshController _controller = EasyRefreshController();

  List _modelList = [];
  int _page = 1;
  int _pageSize = 20;
  bool _noMore = false;

  @override
  void initState() {
    getModelApiData();
    // TODO: implement initState
    super.initState();
  }

  //通过id 查询search接口 分类列表
  getModelApiData() async {
    print("数据请求开始——————通过id 查询search接口 分类列表");
    print(
        "https://www.myminifactory.com/api/v2/search?page=${_page}&per_page=${_pageSize}&sort=visits&cat=${widget.arguments['objId']}&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
    try {
      Response response = await Dio().get(
          "https://www.myminifactory.com/api/v2/search?page=${_page}&per_page=${_pageSize}&sort=visits&cat=${widget.arguments['objId']}&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);
      print("Response->>>>>>>>>>>${response.data['total_count']}");
      //筛选免费模型
      for (int i = 0; i < response.data['items'].length; i++) {
        if (response.data['items'][i]['price'] == null) {
          if (mounted) {
            setState(() {
              _modelList.add(response.data["items"][i]);
            });
          }
        }
      }
      if (response.data['items'].length == 0) {
        if (mounted) {
          setState(() {
            _noMore = true;
          });
        }
      }

      print("数据一页lenght ==${_modelList.length}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
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
            "${widget.arguments['title']}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _modelList.length != 0
            ? Container(
                width: ScreenAdapter.getScreenWidth(),
                child: EasyRefresh(
                    controller: _controller,
                    header: DeliveryHeader(
                      backgroundColor: Colors.grey[100],
                    ),
                    onRefresh: () async {
                      _page = 1;
                      _modelList = [];
                      await getModelApiData();
                      _controller.resetLoadState();
                    },
                    onLoad: () async {
                      print("上拉加载-----");
                      _page = _page + 1;
                      await getModelApiData();
                      _controller.finishLoad(noMore: _noMore);
                    },
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            childAspectRatio: 1),
                        itemCount: _modelList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return _modelPicItem(index);
                        })))
            : Container(
                child: SpinKitWave(
                  color: Color(0xFFF79432),
                  size: 30.0,
                ),
              ),
      ),
    );
  }

  Widget _modelPicItem(index) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/modelDetail",
              arguments: {"objId": _modelList[index]["id"]});
        },
        child: Container(
          height: ScreenAdapter.height(300),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenAdapter.height(240),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      '${_modelList[index]["images"][0]["thumbnail"]["url"]}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(3), 0, ScreenAdapter.width(3), 0),
                decoration: BoxDecoration(color: Colors.white),
                child: Text(
                  "${_modelList[index]['name']}",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Auth: ${_modelList[index]['designer']['username'] == null ? '' : _modelList[index]['designer']['username']}",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ScreenAdapter.size(20)),
                    ),
                    Text(
                      _modelList[index]['designer']['printing_since'] == null
                          ? " "
                          : "${_modelList[index]['designer']['printing_since']['date'].substring(0, 10)}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ScreenAdapter.size(20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
