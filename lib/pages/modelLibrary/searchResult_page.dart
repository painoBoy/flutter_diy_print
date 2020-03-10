import 'package:flutter/material.dart';
import 'dart:ui';
import '../../utils/ScreenAdapter.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SearchResultPage extends StatefulWidget {
  final Map arguments;
  SearchResultPage({Key key, this.arguments}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List _modelList = [];
  var _total_count;
  int _page = 1;
  int _pageSize = 10;

  // @override
  // // TODO: implement mounted
  // bool get mounted => super.mounted;

  @override
  void initState() {
    // TODO: implement initState
    print("111");
    getListData();
    super.initState();
  }

  //请求模型数据
  getListData() async {
    print("数据请求开始----------page = ${_page}");
    print(
        "https://www.myminifactory.com/api/v2/search?q=${widget.arguments['text']}&page=${_page}&per_page=${_pageSize}&sort=popularity&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
    try {
      Response response = await Dio().get(
          "https://www.myminifactory.com/api/v2/search?q=${widget.arguments['text']}&page=${_page}&per_page=${_pageSize}&sort=popularity&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);
      // print("Response->>>>>>>>>>>${response.data['items']['id']}");
      print("response length-----${response.data["items"].length}");

      //筛选免费模型
      if (response.data['items'].length != 0) {
        for (int i = 0; i < response.data['items'].length; i++) {
          print("price ========${response.data['items'][i]['price']}");
          if (response.data['items'][i]['price'] == null) {
            if (mounted) {
              setState(() {
                _total_count = response.data["total_count"];
                _modelList.add(response.data['items'][i]);
              });
            }
          }
        }
      }

      // if (response.data['items'].length != 0) {
      //   if (mounted) {
      //     setState(() {
      //       _total_count = response.data["total_count"];
      //       _modelList.addAll(response.data['items']);
      //     });
      //   }
      // }
      // print(_modelList.length);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // scrollDirection: Axis.vertical,
      children: <Widget>[
        _searchHead(),
        Container(
          alignment: Alignment.topLeft,
          height: ScreenAdapter.getScreenHeight() - ScreenAdapter.height(170),
          child: _modelListWidget(),
        ),
        // Text("${widget.arguments['text']}")
      ],
    ));
  }

  Widget _searchHead() {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        width: ScreenAdapter.getScreenWidth(),
        child: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: ScreenAdapter.width(100),
                    margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                    child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          size: ScreenAdapter.size(65),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Navigator.pushReplacementNamed(context, "/tabs");
                          Navigator.pop(context);
                        })),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(right: ScreenAdapter.width(40)),
                    width: ScreenAdapter.width(488),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/searchModel");
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 8, 5, 8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(
                                "${widget.arguments == null ? '' : widget.arguments['text']}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(30))),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _modelListWidget() {
    if (_modelList.length != 0) {
      return EasyRefresh.custom(
        header: DeliveryHeader(
          backgroundColor: Colors.grey[100],
        ),
        onRefresh: () async {
          _page = 1;
          _modelList = [];
          await getListData();
        },
        onLoad: () async {
          _page = _page + 1;
          await getListData();
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _modelItem(index);
              },
              childCount: _modelList.length,
            ),
          ),
        ],
      );
    } else {
      if (_total_count != null) {
        return Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                    child: Image.asset("assets/images/noData.jpeg"),
                  ),
                  Text("暂无数据",
                      style: TextStyle(fontSize: ScreenAdapter.size(30))),
                ],
              ),
            ));
      } else {
        return Column(
          children: <Widget>[
            Container(
                width: ScreenAdapter.getScreenWidth(),
                height: 110,
                child: Card(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Container(
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(
                                10.0,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 120.0,
                                            height: 15.0,
                                            color: Colors.grey[200],
                                          ),
                                          Container(
                                            width: 60.0,
                                            height: 10.0,
                                            margin: EdgeInsets.only(top: 8.0),
                                            color: Colors.grey[200],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.grey[200],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10.0,
                                        color: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 10.0,
                                        color: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 150.0,
                                        color: Colors.grey[200],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
                width: ScreenAdapter.getScreenWidth(),
                height: 110,
                child: Card(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Container(
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(
                                10.0,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 120.0,
                                            height: 15.0,
                                            color: Colors.grey[200],
                                          ),
                                          Container(
                                            width: 60.0,
                                            height: 10.0,
                                            margin: EdgeInsets.only(top: 8.0),
                                            color: Colors.grey[200],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.grey[200],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10.0,
                                        color: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 10.0,
                                        color: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 150.0,
                                        color: Colors.grey[200],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      }
    }
  }

  Widget _modelItem(index) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/modelDetail",
              arguments: {"objId": _modelList[index]['id']});
        },
        child: Container(
          child: Card(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        // color: Colors.grey[200],
                        child: Image.network(
                            "${_modelList[index]['images'][0]['thumbnail']['url']}"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.all(
                          10.0,
                        ),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 120.0,
                                      // height: 15.0,
                                      child: Text(
                                        "${_modelList[index]['name']}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Container(
                                    //   width: 60.0,
                                    //   height: 10.0,
                                    //   margin: EdgeInsets.only(top: 8.0),
                                    //   color: Colors.grey[200],
                                    // ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.grey[200],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: ScreenAdapter.height(70),
                                  // color: Colors.grey[200],
                                  child: Text(
                                    "${_modelList[index]['description']}",
                                    style: TextStyle(
                                        fontSize: ScreenAdapter.size(20)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Container(
                                  height: 10.0,
                                  // color: Colors.grey[200],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Container(
                                  // height: 10.0,
                                  // width: 150.0,
                                  child: _modelList[index]['designer']
                                              ['printing_since'] !=
                                          null
                                      ? Text(
                                          "${_modelList[index]['designer']['printing_since']['date'].substring(0, 10)}")
                                      : Text(''),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
    // Container(
    //     padding: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
    //     decoration: BoxDecoration(
    //       border: Border(
    //         bottom: BorderSide(
    //             width: ScreenAdapter.height(1), color: Colors.grey[600]),
    //       ),
    //     ),
    //     child: Row(
    //       children: <Widget>[
    //         Container(
    //           width: ScreenAdapter.width(300),
    //           height: ScreenAdapter.height(200),
    //           child: Image.network(
    //             "http://jd.itying.com/public/upload/Hfe1i8QDOkfVt-PuGcxCA0fs.jpg",
    //           ),
    //         ),
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: <Widget>[
    //             Container(
    //               child: Text(
    //                 "飞机",
    //               ),
    //             ),
    //             Container(
    //               child: Text("作者XXX"),
    //             ),
    //             Container(
    //               child: Row(
    //                 children: <Widget>[
    //                   Container(
    //                     child: Text("view: 30203"),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               child: Text("2019-12-02"),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ));
  }
}
