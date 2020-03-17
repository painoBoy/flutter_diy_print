/*
 * @Author: your name
 * @Date: 2020-03-02 15:21:39
 * @LastEditTime: 2020-03-16 17:12:43
 * @LastEditors: Please set LastEditors
 * @Description: 打印历史记录页
 * @FilePath: /diy_3d_print/lib/pages/account/collection_page.dart
 */

import '../../utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/printTaskList.dart';
import '../../network/http_config.dart';
import '../../network/api.dart';
import '../../network/http_request.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class PrintHistoryPage extends StatefulWidget {
  @override
  _PrintHistoryPageState createState() => _PrintHistoryPageState();
}

class _PrintHistoryPageState extends State<PrintHistoryPage> {
  int _page = 1;
  int _pageSize = 10;
  List _printStatusList = [
    "All",
    "Waiting to print",
    "Printing...",
    "Print successfully",
    "Printing failed",
    "Printing in progress",
    "Offline during printing",
    "Pause printing",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrintTaskList();
  }

  //获取用户所有打印任务
  getPrintTaskList() async {
    var res = await NetRequest.get(
        Config.BASE_URL + userTaskList + "/${_pageSize}/${_page}/0");
    if (res["code"] == 200) {
      Provider.of<PrintTaskProvider>(context).getUserPrintTaskList(res["data"]);
    } else {
      showToast(res["msg"],
          position: ToastPosition.bottom, backgroundColor: Colors.green[400]);
    }
  }

  @override
  Widget build(BuildContext context) {
    List _printTaskData = Provider.of<PrintTaskProvider>(context).taskList;
    ScreenAdapter.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: WillPopScope(
            onWillPop: () {
              Provider.of<PrintTaskProvider>(context).clearUserPrintTaskList();
              Navigator.pop(context);
            },
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(Icons.keyboard_arrow_left,
                          color: Colors.white, size: ScreenAdapter.size(80)),
                      onPressed: () {
                        Provider.of<PrintTaskProvider>(context)
                            .clearUserPrintTaskList();
                        Navigator.pop(context);
                      }),
                  brightness: Brightness.light,
                  title: Text(
                    "Print History",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: _printTaskData.length != 0
                    ? EasyRefresh.custom(
                        header: DeliveryHeader(
                          backgroundColor: Colors.grey[100],
                        ),
                        onRefresh: () async {
                          _page = 1;
                          Provider.of<PrintTaskProvider>(context)
                              .clearUserPrintTaskList();
                          await getPrintTaskList();
                        },
                        onLoad: () async {
                          _page = _page + 1;
                          await getPrintTaskList();
                        },
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _collectList(index);
                              },
                              childCount: _printTaskData.length,
                            ),
                          ),
                        ],
                      )
                    : Container(child: Text("无数据")))));
  }

  Widget _collectList(index) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(220),
            height: ScreenAdapter.height(140),
            // color: Colors.grey,
            child: Provider.of<PrintTaskProvider>(context).taskList[index]
                        ["modelIcon"] ==
                    ""
                ? Center(child: Text("No Data"))
                : Image.network(
                    "${Provider.of<PrintTaskProvider>(context).taskList[index]["modelIcon"]}",
                    fit: BoxFit.fill),
          ),
          Column(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                child: Text("print status:",
                    style: TextStyle(
                        fontSize: ScreenAdapter.size(30),
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Text(
                  _printStatusList[Provider.of<PrintTaskProvider>(context)
                      .taskList[index]['printstate']],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child:Text("失败原因:")),
                Container(child:Text(Provider.of<PrintTaskProvider>(context)
                      .taskList[index]['errormessage'])),
              ],
            ),
            ],
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Container(
          //       child: Text("print status:",
          //           style: TextStyle(
          //               fontSize: ScreenAdapter.size(30),
          //               fontWeight: FontWeight.bold)),
          //     ),
          //     Container(
          //       child: Text(
          //         _printStatusList[Provider.of<PrintTaskProvider>(context)
          //             .taskList[index]['printstate']],
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   child:Column(children: <Widget>[
          //     Text(Provider.of<PrintTaskProvider>(context)
          //             .taskList[index]['errormessage'])
          //   ],)
          // )
          // Container(
          //   margin: EdgeInsets.only(right: ScreenAdapter.width(30)),
          //   width: ScreenAdapter.width(180),
          //   alignment: Alignment.center,
          //   height: ScreenAdapter.height(60),
          //   decoration: BoxDecoration(
          //       color: Color(0xFFF79432),
          //       borderRadius: BorderRadius.circular(10)),
          //   child: Text(
          //     "Print",
          //     style: TextStyle(
          //         color: Colors.white, fontSize: ScreenAdapter.size(35)),
          //   ),
          // ),
        ],
      )),
    );
  }
}
