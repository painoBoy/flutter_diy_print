import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../utils/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../../models/modelLib_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../modelLib_json.dart';
import 'package:transparent_image/transparent_image.dart';
import './test_demo.dart';

class ModelLibraryPage extends StatefulWidget {
  @override
  _ModelLibraryPageState createState() => _ModelLibraryPageState();
}

class _ModelLibraryPageState extends State<ModelLibraryPage> {
  List _modelList = [];
  int total_count = 0;
  List _modelJsonList = [];
  ModelLibraryModel res;
  List _swiperData = [];

  @override
  void initState() {
    _modelJsonList = ModelJsonList;
    getSwiperList();

    getApiData();
    // TODO: implement initState
    super.initState();
  }

  //获取一级分类id
  getApiData() async {
    try {
      Response response = await Dio().get(
          "https://www.myminifactory.com/api/v2/categories?top=false&page=1&per_page=8&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);
      res = ModelLibraryModel.fromJson(response.data);
      print("获取分类————————————");
      setState(() {
        // total_count = response.data["total_count"];
        _modelList = res.items;
      });
    } catch (e) {
      print(e);
    }
  }

  //获取Swiper数据
  getSwiperList() async {
    try {
      Response response = await Dio().get(
          "https://www.myminifactory.com/api/v2/search?page=1&per_page=4&sort=popularity&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);
      print("获取Swiper+++++++++++++++");
      setState(() {
        // total_count = response.data["total_count"];
        _swiperData = response.data["items"];
      });
      print(_swiperData.length);
    } catch (e) {
      print(e);
    }
  }

  getModelLibData() async {
    try {
      Response response = await Dio().get(
          "https: //www.myminifactory.com/api/v2/search?q=null&page=1&per_page=10&cat=154&sortBy=popularity&key=3a934958-fd58-4a42-ae15-7da531a0cd80");
      // print(response);

      setState(() {
        // total_count = response.data["total_count"];
        _modelList = res.items;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    print("页面刷新_________________");
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                brightness: Brightness.light,
                title: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DemoPage()));
                    },
                    child: Text(
                      // "Models Library",
                      "MyMinifactory Models Lib ",
                      style: TextStyle(color: Colors.white),
                    )),
                actions: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/searchModel");
                      },
                      child: Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.search,
                            size: ScreenAdapter.size(50),
                            color: Colors.white,
                          )))
                ]),
            body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
              _swiper(),
              _gridMenu(),
              _education(context),
              _bottomNotice(),
            ])));
  }

  //底部提示
  Widget _bottomNotice() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(200),
            height: ScreenAdapter.height(2),
            decoration: BoxDecoration(color: Colors.grey),
          ),
          Text(" it's limit "),
          Container(
            width: ScreenAdapter.width(200),
            height: ScreenAdapter.height(3),
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  //轮播
  Widget _swiper() {
    if (_swiperData.length != 0) {
      return Container(
        padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(400),
        child: Swiper(
          // viewportFraction: 0.8,
          // scale: 0.9,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Image.network(
                  "${_swiperData[index]['images'][0]['thumbnail']['url']}",
                  fit: BoxFit.fill,
                  width: ScreenAdapter.getScreenWidth(),
                ),
                Positioned(
                    bottom: ScreenAdapter.height(50),
                    child: Container(
                        width: ScreenAdapter.getScreenWidth(),
                        alignment: Alignment.center,
                        child: Text(
                          "${_swiperData[index]['name']}",
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        )))
              ],
            );
          },
          autoplay: true,
          loop: true,
          itemCount: _swiperData.length,
          pagination: new SwiperPagination(),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(400),
        child: SpinKitWave(
          color: Color(0xFFF79432),
          size: 20.0,
        ),
      );
    }
  }

  // Widget _gridMenu(){
  //   return Container(
  //     child: GridView.count(crossAxisCount: 5,padding: EdgeInsets.all(4.0),
  //         children: gridDataList.map((item) {
  //           return _gridViewItemUI(context, item);
  //         }).toList(),)
  //   );
  // }

  //分类导航
  Widget _gridMenu() {
    if (_modelList.length == 0) {
      return SpinKitWave(
        color: Color(0xFFF79432),
        size: 40.0,
      );
    }
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(50)),
        height: ScreenAdapter.height(320),
        width: ScreenAdapter.getScreenWidth(),
        child: 
        GridView.count(
          scrollDirection: Axis.horizontal,
          physics: new NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio:1,
          padding: EdgeInsets.all(ScreenAdapter.width(5)),
          children: _modelList.map((item) {
            return _gridItem(item);
          }).toList(),
        ),
        );
  }

  //分类item
  Widget _gridItem(item) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/modelList",
            arguments: {"objId": item.id, "title": item.name},
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child:
                        // FadeInImage.assetNetwork(
                        //   placeholder: '',
                        //   image:
                        //       "https://cdn.myminifactory.com/assets/object-assets/579fa0960f9be/images/70X70-8491a2feed6f116e1457d5f970b500b2a415be54.jpg",
                        //   width: ScreenAdapter.width(150),
                        // ),
                        Image.network(
                      "https://cdn.myminifactory.com/assets/object-assets/579fa0960f9be/images/70X70-8491a2feed6f116e1457d5f970b500b2a415be54.jpg",
                      // width: ScreenAdapter.width(200),
                      fit: BoxFit.cover,
                      headers: {
                        "Cookie":
                            "device_view=full; hl=en; __cfduid=dce88bcc271c0ed1315b2d9ef2be5fd121582007209; _pk_testcookie..undefined=1; _pk_testcookie.1.2bd0=1; _pk_ses.1.2bd0=1; _ga=GA1.2.277281702.1582007213; _gid=GA1.2.2010046157.1582007213; __gads=ID=cac1498818c2c75e:T=1582007382:S=ALNI_MZ5nSkbMVp0otpuxzdQXxbaEe__kQ; SESSID=7f372812d0a3962f03d0b3c5b592a945; _pk_id.1.2bd0=6881566e9711e610.1582007212.1.1582010421.1582007212."
                      },
                    )
                    //       CachedNetworkImage(
                    //         width: ScreenAdapter.width(150),
                    //         fit: BoxFit.fill,
                    //     imageUrl: "https://cdn.myminifactory.com/assets/object-assets/579fa0960f9be/images/70X70-8491a2feed6f116e1457d5f970b500b2a415be54.jpg",
                    //     placeholder: (context, url) => CircularProgressIndicator(),
                    //     errorWidget: (context, url, error) => Icon(Icons.error),
                    //  ),
                    // Image.network(
                    //   "https://cdn.myminifactory.com/assets/object-assets/579fa0960f9be/images/70X70-8491a2feed6f116e1457d5f970b500b2a415be54.jpg",
                    //   width: ScreenAdapter.width(150),
                    //   fit: BoxFit.fill,
                    // ),
                    ),
                Container(
                    alignment: Alignment.center,
                    // width: ScreenAdapter.width(160),
                    child: Text(
                      "${item.name}",
                      style: TextStyle(fontSize: ScreenAdapter.size(16)),
                      overflow: TextOverflow.visible,
                    ))
              ]),
        ));
    // Image.network(
    //                   "https://cdn.myminifactory.com/assets/object-assets/579fa0960f9be/images/70X70-8491a2feed6f116e1457d5f970b500b2a415be54.jpg",
    //                   // width: ScreenAdapter.width(160),
    //                   fit: BoxFit.cover,
    //                   headers: {
    //                     "Cookie":
    //                         "device_view=full; hl=en; __cfduid=dce88bcc271c0ed1315b2d9ef2be5fd121582007209; _pk_testcookie..undefined=1; _pk_testcookie.1.2bd0=1; _pk_ses.1.2bd0=1; _ga=GA1.2.277281702.1582007213; _gid=GA1.2.2010046157.1582007213; __gads=ID=cac1498818c2c75e:T=1582007382:S=ALNI_MZ5nSkbMVp0otpuxzdQXxbaEe__kQ; SESSID=7f372812d0a3962f03d0b3c5b592a945; _pk_id.1.2bd0=6881566e9711e610.1582007212.1.1582010421.1582007212."
    //                   },
    //                 );
  }

  Widget _catListWidget() {
    return Expanded(
        child: Container(
      width: ScreenAdapter.getScreenWidth(),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _modelJsonList.length,
          itemBuilder: (context, int index) {
            return Column(
              children: <Widget>[
                _educationTitle(context, _modelJsonList[index]),
                _educationBanners(_modelJsonList[index], context),
              ],
            );
          }),
    ));
  }

  //分类板块
  Widget _education(context) {
    return Column(
        children: _modelJsonList.map((item) {
      return Container(
          child: Column(children: <Widget>[
        _educationTitle(context, item),
        _educationBanners(item, context),
      ]));
    }).toList());
  }
}

//分类标题
Widget _educationTitle(context, item) {
  return Container(
      width: ScreenAdapter.getScreenWidth(),
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(20),
          ScreenAdapter.height(20),
          ScreenAdapter.width(20),
          ScreenAdapter.height(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5),
                width: ScreenAdapter.width(7),
                height: ScreenAdapter.height(25),
                decoration: BoxDecoration(color: Color(0xFFF79432)),
              ),
              Text("${item['title']}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          InkWell(
            onTap: () {
              print(item['catId']);
              Navigator.pushNamed(
                context,
                "/modelList",
                arguments: {"objId": item['catId'], "title": item['title']},
              );
            },
            child: Row(children: <Widget>[
              Text("more"),
              Icon(Icons.keyboard_arrow_right)
            ]),
          ),
        ],
      ));
}

//分类model图片
Widget _educationBanners(item, context) {
  return Container(
    width: ScreenAdapter.getScreenWidth(),
    padding: EdgeInsets.fromLTRB(
        ScreenAdapter.width(20),
        ScreenAdapter.height(20),
        ScreenAdapter.width(20),
        ScreenAdapter.height(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/modelDetail",
                arguments: {"objId": item['imageList'][0]['objId']});
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${item['imageList'][0]['url']}',
                    fit: BoxFit.cover,
                    width: ScreenAdapter.getScreenWidth() / 3 -
                        ScreenAdapter.width(20),
                    height: ScreenAdapter.height(200),
                  ),
                ),
                // Image.network(
                //   "${item['imageList'][0]['url']}",
                //   fit: BoxFit.cover,
                //   width: ScreenAdapter.getScreenWidth() / 3 -
                //       ScreenAdapter.width(20),
                //   height: ScreenAdapter.height(200),
                // ),
                Positioned(
                    bottom: 0,
                    child: Container(
                        width: ScreenAdapter.getScreenWidth() / 3 -
                            ScreenAdapter.width(20),
                        height: ScreenAdapter.height(20),
                        decoration: BoxDecoration(),
                        alignment: Alignment.center,
                        child: Text(
                          "${item['imageList'][0]['userName']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdapter.size(18),
                          ),
                          textAlign: TextAlign.center,
                        ))),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/modelDetail",
                arguments: {"objId": item['imageList'][1]['objId']});
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                // Image.network(
                //   "${item['imageList'][1]['url']}",
                //   fit: BoxFit.cover,
                //   width: ScreenAdapter.getScreenWidth() / 3 -
                //       ScreenAdapter.width(20),
                //   height: ScreenAdapter.height(200),
                // ),
                Container(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${item['imageList'][1]['url']}',
                    fit: BoxFit.cover,
                    width: ScreenAdapter.getScreenWidth() / 3 -
                        ScreenAdapter.width(20),
                    height: ScreenAdapter.height(200),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                        width: ScreenAdapter.getScreenWidth() / 3 -
                            ScreenAdapter.width(20),
                        height: ScreenAdapter.height(20),
                        decoration: BoxDecoration(),
                        alignment: Alignment.center,
                        child: Text(
                          "${item['imageList'][1]['userName']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdapter.size(18),
                          ),
                          textAlign: TextAlign.center,
                        ))),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/modelDetail",
                arguments: {"objId": item['imageList'][2]['objId']});
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                // Image.network(
                //   "${item['imageList'][2]['url']}",
                //   fit: BoxFit.cover,
                //   width: ScreenAdapter.getScreenWidth() / 3 -
                //       ScreenAdapter.width(20),
                //   height: ScreenAdapter.height(200),
                // ),
                Container(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${item['imageList'][2]['url']}',
                    fit: BoxFit.cover,
                    width: ScreenAdapter.getScreenWidth() / 3 -
                        ScreenAdapter.width(20),
                    height: ScreenAdapter.height(200),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                        width: ScreenAdapter.getScreenWidth() / 3 -
                            ScreenAdapter.width(20),
                        height: ScreenAdapter.height(20),
                        decoration: BoxDecoration(),
                        alignment: Alignment.center,
                        child: Text(
                          "${item['imageList'][2]['userName']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdapter.size(18),
                          ),
                          textAlign: TextAlign.center,
                        ))),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
