/*
 * @Author: liaozhou
 * @Date: 2020-02-26 15:29:03
 * @LastEditTime: 2020-02-28 15:54:38
 * @LastEditors: Please set LastEditors
 * @Description: 模型库搜索页面
 * @FilePath: /diy_3d_print/lib/pages/modelLibrary/searchModel_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/ScreenAdapter.dart';
import 'dart:ui';
import '../../utils/searchService.dart';
import 'dart:io';

class SearchModelPage extends StatefulWidget {
  @override
  _SearchModelPageState createState() => _SearchModelPageState();
}

class _SearchModelPageState extends State<SearchModelPage> {
  List _historyListData = []; //历史记录

  @override
  void initState() {
    // TODO: implement initState
    _getHistoryData();
    super.initState();
  }

  _submit(text) {
    print("点击键盘搜索---->${text}");
  }

  _handleClick(keyword) {
    Navigator.pushNamed(context, "/searchResult", arguments: {"text": keyword})
        .then((res) {
      _getHistoryData();
    });
  }

  //获取本地搜索历史记录
  _getHistoryData() async {
    var _historyListData = await SearchServices.getHistoryList();
    if (mounted)
      setState(() {
        this._historyListData = _historyListData;
      });
  }

  //删除历史记录

  _deleteHistory() async {
    if (Platform.isIOS) {
      await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Are you sure you want to delete?',
                  style: TextStyle(fontSize: ScreenAdapter.size(30))),
              // content: Text('删除成功无法恢复'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop("0");
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop("1");
                    SearchServices.clearHistoryList();
                    _getHistoryData();
                  },
                ),
              ],
            );
          });
    } else if (Platform.isAndroid) {
      await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Are you sure you want to delete?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenAdapter.size(30)),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Deleting this part will permanently erase it.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("0");
                  },
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop("1");
                    SearchServices.clearHistoryList();
                    _getHistoryData();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _searchHead(),
          _searchNotice(),
        ],
      ),
    ));
  }

  //自定义搜索框
  Widget _searchHead() {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        width: ScreenAdapter.getScreenWidth(),
        child: Container(
          margin: EdgeInsets.fromLTRB(ScreenAdapter.width(38), 0,
              ScreenAdapter.width(0), ScreenAdapter.height(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: ScreenAdapter.width(488),
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    onSubmitted: (text) {
                      SearchServices.setHistoryData(text);
                      Navigator.pushNamed(context, "/searchResult",
                          arguments: {"text": text}).then((res) {
                        this._getHistoryData();
                      });
                    },
                    // style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      icon: GestureDetector(
                        onTap: () {
                          // fetchData();
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: "search you want",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenAdapter.width(130),
                  margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
                  child: Text("Cancel",
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(30),
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _searchNotice() {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            alignment: Alignment.centerLeft,
            width: ScreenAdapter.getScreenWidth(),
            child: Text("搜索发现")),
        Container(
            padding: EdgeInsets.only(left: ScreenAdapter.width(22)),
            alignment: Alignment.centerLeft,
            width: ScreenAdapter.getScreenWidth(),
            child: Wrap(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _handleClick('Store');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("Store"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleClick('robot');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("robot"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleClick('Education');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("Education"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleClick('Scan the World');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("Scan the World"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleClick('Accessibility');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("Accessibility"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _handleClick('plane');
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("plane"),
                  ),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(20), 0, ScreenAdapter.width(20), 0),
          alignment: Alignment.centerLeft,
          width: ScreenAdapter.getScreenWidth(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("最近搜索"),
              IconButton(icon: Icon(Icons.delete), onPressed: _deleteHistory)
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: ScreenAdapter.width(22)),
            alignment: Alignment.centerLeft,
            width: ScreenAdapter.getScreenWidth(),
            child: Wrap(
              children: _historyListData.map((value) {
                return InkWell(
                  onTap: () {
                    _handleClick(value);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.size(20)),
                        color: Colors.grey[300]),
                    child: Text("${value}"),
                  ),
                );
              }).toList(),
              //     <Widget>[
              //   Container(
              //     margin: EdgeInsets.all(5),
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(ScreenAdapter.size(20)),
              //         color: Colors.grey[300]),
              //     child: Text("奥术大师大"),
              //   ),
              //   Container(
              //     margin: EdgeInsets.all(5),
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(ScreenAdapter.size(20)),
              //         color: Colors.grey[300]),
              //     child: Text("你我们哦阿斯顿"),
              //   ),
              //   Container(
              //     margin: EdgeInsets.all(5),
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(ScreenAdapter.size(20)),
              //         color: Colors.grey[300]),
              //     child: Text("奥术大师大所"),
              //   ),
              //   Container(
              //     margin: EdgeInsets.all(5),
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(ScreenAdapter.size(20)),
              //         color: Colors.grey[300]),
              //     child: Text("奥术大师大是的"),
              //   ),
              //   Container(
              //     margin: EdgeInsets.all(5),
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.circular(ScreenAdapter.size(20)),
              //         color: Colors.grey[300]),
              //     child: Text("按时"),
              //   ),
              // ],
            )),
      ],
    ));
  }
}
