import 'package:flutter_diy_print/pages/workspace/home_page.dart';

import '../../network/api.dart';
import '../../network/http_config.dart';
import '../../network/http_request.dart';
import 'dart:async';
import '../../utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../provider/printCommand.dart';
import '../../widget/loading.dart';

class ModelDetailPage extends StatefulWidget {
  final Map arguments;
  ModelDetailPage({Key key, this.arguments}) : super(key: key);
  @override
  _ModelDetailPageState createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
  bool _isCollection = false;
  bool _isTooSmall = false; // 模型过小则不能打印
  Map _modelData;
  int _currentIndex = 0;
  Timer _timer;
  List _favorite = [];
  bool isLoading = false;
  int _downLoadProgress = 0;
  List printTaskStats = [
    "all",
    "Waiting to print",
    "Printing...",
    "Print successfully",
    "Print Failed",
    "Print ready...",
    "Offline during printer",
    "Printing paused"
  ];
  @override
  void initState() {
    // TODO: implement initState
    getApiData();
    getFavoriteList(); //获取收藏列表
    super.initState();
  }

  //获取收藏列表
  getFavoriteList() async {
    print("请求收藏列表=======》");
    var res = await NetRequest.get(Config.BASE_URL + favoriteList);
    print("res=${res}");
    if (res["data"] != null) {
      _favorite = res["data"];
      print("_favorite=${_favorite}");
      for (int i = 0; i < res["data"].length; i++) {
        if (res["data"][i]["id"] == widget.arguments["objId"].toString()) {
          print("有");
          if (mounted) {
            setState(() {
              _isCollection = true;
            });
          }
          break;
        }
      }
    }
  }

  //id 获取obj对象
  getApiData() async {
    print("数据请求开始");
    print(
        "https://www.myminifactory.com/api/v2/objects/${widget.arguments["objId"]}?page=1&per_page=8&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
    try {
      Response response = await Dio().get(
          "https://www.myminifactory.com/api/v2/objects/${widget.arguments["objId"]}?page=1&per_page=8&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);
      print("Response->>>>>>>>>>>");
      if (mounted) {
        setState(() {
          // total_count = response.data["total_count"];
          _modelData = response.data;
        });
      }
      print(_modelData);
    } catch (e) {
      print(e);
    }
  }

  /*打印模型 
   *  step1: 获取模型大小
   *  step2:通过step1 response里的ID轮询查询进度
   *  step3:进度 -1 表示出错 100表示获取
   *  step4：拿到 模型x、y、z 数据 与 打印机 xyz 判断 
   *  step5: 条件通过则创建打印任务
  */
  _printModel(fileName, modelImageUrl) async {
    if (mounted)
      setState(() {
        _downLoadProgress = 0;
        isLoading = true;
      });
    //判断打印机状态 为1时才能打印
    var printInfoResult = await NetRequest.get(Config.BASE_URL +
        printerInfo +
        "/${Provider.of<PrinterIdProvider>(context).printId}");
    if (printInfoResult["code"] == 200) {
      if (printInfoResult["data"]["printState"] != 1) {
        setState(() {
          isLoading = false;
        });
        showToast("Printer is not idle",
            position: ToastPosition.bottom, backgroundColor: Colors.grey[400]);
        return;
      }
    }

    List modelUrlList = []; //模型下载地址
    var modelPrintId; //response id
    modelUrlList.add(
        "https://www.myminifactory.com/download/${widget.arguments['objId']}?downloadfile=${fileName}");
    print(Config.BASE_URL + modelSize);

    var res =
        await NetRequest.post(Config.BASE_URL + modelSize, data: modelUrlList);
    if (res["code"] == 200) {
      modelPrintId = res["data"];
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        // 定时器 查询 模型下载进度
        var result = await NetRequest.get(
            Config.BASE_URL + checkModel + "/${modelPrintId}");
        print(Config.BASE_URL + checkModel + "/${modelPrintId}");

        if (result["code"] == 200) {
          print("progress = ${result["data"]}");

          if (_downLoadProgress != result["data"]["progress"]) {
            setState(() {
              _downLoadProgress = result["data"]["progress"];
            });
          }
          if (result["data"]["progress"] == -1) {
            if (mounted)
              setState(() {
                isLoading = false;
              });
            showToast("system error",
                position: ToastPosition.bottom,
                backgroundColor: Colors.grey[400]);
            timer.cancel();
            timer = null;
          } else if (result["data"]["progress"] == 100) {
            timer.cancel();
            timer = null;
            print(result["data"]["modelSizeInfos"][0]);
            //模型大小和打印机电机运动范围比较
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List tempMotorStroke = prefs.getString("printSize").split(",");
            var _newtempMotorStroke = tempMotorStroke.map((val) {
              return double.tryParse(val);
            }).toList();
            bool isCanPrint = false;
            for (int i = 0; i < _newtempMotorStroke.length; i++) {
              if (result["data"]["modelSizeInfos"][0]["modelSize"][i] <
                  _newtempMotorStroke[i]) {
                isCanPrint = true;
              } else {
                isCanPrint = false;
                break; // 如果模型条件有不满足打印条件 立即跳出
              }
            }
            //遍历x、y、z轴是否有小于40mm 有则不能打印
            for (int i = 0; i < _newtempMotorStroke.length; i++) {
              if (result["data"]["modelSizeInfos"][0]["modelSize"][i] > 40) {
                _isTooSmall = false;
              } else {
                _isTooSmall = true;
                break; // 如果模型条件有不满足打印条件 立即跳出
              }
            }

            if (isCanPrint && !_isTooSmall) {
              print("能打印了");
              Map _taskParams = {
                "printerId": prefs.getInt("selectedPrintId"),
                "icon": modelImageUrl == null ? "null" : modelImageUrl,
                "printOverall": true,
                "cloudPrinte": false,
                "printModel": [
                  {"extruder": 1, "model": modelPrintId, "scaling": -1},
                ]
              };
              //发起打印任务
              var res = await NetRequest.post(Config.BASE_URL + createPrintTask,
                  data: _taskParams);
              print(res);
              if (mounted)
                setState(() {
                  isLoading = false;
                });
              if (res["code"] == 200) {
                if (res["data"]["started"]) {
                  //存储当前打印任务code 至workspace查询
                  showToast("The print task was initiated successfully",
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey[600]);
                  Provider.of<PrinterIdProvider>(context).changePrintTaskCode(
                      res['data']['printTaskList'][0]['taskcode']);
                  Provider.of<PrinterIdProvider>(context)
                      .changePrinterTaskStatus(1); // 通知Provider有打印任务
                  Navigator.pushNamedAndRemoveUntil(context, "/tabs",
                      (Route route) => route.settings.name == '/');
                  childKey.currentState.checkPrintTaskStatus();
                } else {
                  showToast(res["data"]["printTaskList"]["errormessage"],
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.grey[600]);
                }
              } else {
                showToast(res["msg"],
                    position: ToastPosition.bottom,
                    backgroundColor: Colors.grey[600]);
              }
            } else if (!isCanPrint) {
              if (mounted)
                setState(() {
                  isLoading = false;
                });
              showToast("The Model size is too large",
                  backgroundColor: Colors.grey[600]);
            } else if (_isTooSmall) {
              if (mounted)
                setState(() {
                  isLoading = false;
                });
              showToast("The Model size is too Small",
                  backgroundColor: Colors.grey[600]);
            }
            print("太小了吗?${_isTooSmall}");
            print("打印机=====> ${_newtempMotorStroke}");
            print(
                "模型大小=====> ${result["data"]["modelSizeInfos"][0]["modelSize"]}");
            print("能打印机吗======>${isCanPrint}");
          }
        } else {
          print(result["msg"]);
        }
      });
    }
  }

  //发起打印机任务
  // startPrintTask() async {
  //   var res = await NetRequest.post(Config.BASE_URL + printTaskApi);
  // }

  //收藏
  _collection() async {
    if (_modelData == null) return;

    if (_isCollection) {
      var res = await NetRequest.get(
          Config.BASE_URL + unFavorite + "/${_modelData['id']}");
      if (res["code"] == 200) {
        if (mounted) {
          setState(() {
            _isCollection = !_isCollection;
          });
        }
        print("取消收藏");
        showToast("Successfully uncollected",
            position: ToastPosition.top, backgroundColor: Colors.grey[500]);
      } else {
        showToast(res["msg"],
            position: ToastPosition.top, backgroundColor: Colors.grey[500]);
      }
    } else {
      Map params = {
        "id": _modelData["id"].toString(),
        "icon": _modelData["images"][0]["thumbnail"]["url"],
        "name": _modelData["name"].length > 30
            ? _modelData["name"].toString().substring(0, 30)
            : _modelData["name"],
        "desc": _modelData["description"].toString().length > 30
            ? _modelData["description"].toString().substring(0, 30)
            : _modelData["description"].toString()
      };
      var res = await NetRequest.post(Config.BASE_URL + favorite, data: params);
      if (res['code'] == 200) {
        if (mounted) {
          setState(() {
            _isCollection = !_isCollection;
          });
        }
        print("收藏成功");
        showToast("Successful collection",
            position: ToastPosition.top, backgroundColor: Colors.grey[500]);
      } else {
        print(res['msg']);
      }
    }
  }

  _changeIndex(index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  //页面关闭销毁timer
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
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
            title: Text(
              "Details of the Model",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(
                      _isCollection ? Icons.favorite : Icons.favorite_border,
                      size: ScreenAdapter.size(60),
                      color: Colors.white,
                    ),
                    onPressed: _collection,
                  ))
            ],
          ),
          body: _modelData != null
              ? ProgressDialog(
                  loading: isLoading,
                  msg:
                      'The model has been downloaded by ${_downLoadProgress}%...',
                  child: ListView(children: <Widget>[_banner()]
                      // physics: NeverScrollableScrollPhysics(),
                      ))
              : SpinKitWave(
                  color: Color(0xFFF79432),
                  size: 20.0,
                ),
        ));
  }

  Widget _banner() {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 8,
          child: FadeInImage.assetNetwork(
            placeholder: "",
            image: "${_modelData['images'][_currentIndex]['original']['url']}",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: ScreenAdapter.height(120),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _modelData['images'].length,
              itemBuilder: (context, int index) {
                return _imageItem(index);
              }),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20),
              ScreenAdapter.height(20), 0, ScreenAdapter.height(20)),
          padding: EdgeInsets.only(left: ScreenAdapter.width(15)),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: ScreenAdapter.width(4), color: Color(0xFFF79432)),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text("Widget List",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenAdapter.size(30))),
        ),
        Container(
          padding: EdgeInsets.only(bottom: ScreenAdapter.height(200)),
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _modelData['files']["items"].length,
              itemBuilder: (context, int index) {
                return _printWidgetItem(index);
              }),
        ),
      ],
    );
  }

  // 图片item
  Widget _imageItem(index) {
    return InkWell(
        onTap: () {
          this._changeIndex(index);
        },
        child: Container(
          decoration: BoxDecoration(
              border: _currentIndex == index
                  ? Border.all(
                      width: ScreenAdapter.width(4), color: Color(0xFFF79432))
                  : Border.all(width: 0)),
          margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
          width: ScreenAdapter.width(100),
          height: ScreenAdapter.width(100),
          child: Image.network(
            "${_modelData['images'][index]['tiny']['url']}",
            fit: BoxFit.fill,
          ),
        ));
  }

  //打印部件item
  Widget _printWidgetItem(index) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: ScreenAdapter.width(1), color: Colors.grey[400])),
              width: ScreenAdapter.width(200),
              height: ScreenAdapter.width(200),
              child: Image.network(
                  "${_modelData['files']['items'][index]['thumbnail_url']}"),
            ),
            Container(
              width: ScreenAdapter.width(300),
              child: Column(
                children: <Widget>[
                  Text(
                    "${_modelData['files']['items'][index]['filename']}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _printModel(_modelData['files']['items'][index]['filename'],
                    _modelData['files']['items'][index]['thumbnail_url']);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                decoration: BoxDecoration(
                    color: Color(0xFFF79432),
                    borderRadius:
                        BorderRadius.circular(ScreenAdapter.size(20))),
                child: Text(
                  "Print",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
