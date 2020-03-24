import 'package:dio/dio.dart';
import 'http_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
import '../utils/router.dart';

class HttpRequest {
  static BaseOptions baseOptions = BaseOptions(
      baseUrl: Config.BASE_URL,
      connectTimeout: Config.TIMEOUT,
      headers: {
        "Cookie":
            "device_view=full; hl=en; __cfduid=dce88bcc271c0ed1315b2d9ef2be5fd121582007209; _pk_testcookie..undefined=1; _pk_testcookie.1.2bd0=1; _pk_ses.1.2bd0=1; _ga=GA1.2.277281702.1582007213; _gid=GA1.2.2010046157.1582007213; __gads=ID=cac1498818c2c75e:T=1582007382:S=ALNI_MZ5nSkbMVp0otpuxzdQXxbaEe__kQ; SESSID=7f372812d0a3962f03d0b3c5b592a945; _pk_id.1.2bd0=6881566e9711e610.1582007212.1.1582010421.1582007212."
      });
  // 1.创建dio实例
  static final dio = Dio(baseOptions);

  static Future request(String url,
      {String method = "get", Map<String, dynamic> params}) async {
    //2.发送网络请求
    Options options = Options(method: method);
    try {
      print("prams:==${params}");
      final result =
          await dio.request(url, queryParameters: params, options: options);
      return result;
    } on DioError catch (err) {
      throw err;
    }
  }
}

getCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("JSESSIONID") == null) {
    return '';
  }
  return prefs.getString("JSESSIONID");
}

/**
 * @description: 统一封装网络请求 
 * @param {type} 
 * @return: 
 */
class Http {
  static BaseOptions options = BaseOptions(
      // 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
      baseUrl: Config.BASE_URL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 5000,

      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
      ///  注意: 这并不是接收数据的总时限.
      receiveTimeout: 3000,
      headers: {});

  static Dio dio = Dio(options);

  static Future get({
    @required String path,
    Map data = const {},
    options,
    cancelToken,
  }) async {
    print('get请求启动! url：$path ,body: $data');
    Response response;
    // data.addAll({'key': newsKey});

    try {
      response = await dio.get(
        path,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      print('get请求完成!');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      }
      print('get请求发生错误：$e');
    }
    return response.data;
  }

  static Future post({
    @required String path,
    Map data = const {},
    options,
    cancelToken,
  }) async {
    print('post请求启动! url：$path ,body: $data ');
    Response response;
    // data.addAll({'key': newsKey});

    try {
      response = await dio.post(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      print('post请求成功!response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      }
      print('post请求发生错误：$e');
    }
    return response.data;
  }
}

class NetRequest {
  static BaseOptions options = BaseOptions(
      // 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
      baseUrl: Config.BASE_URL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 5000,

      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
      ///  注意: 这并不是接收数据的总时限.
      receiveTimeout: 3000,
      headers: {});

  static get(path, {params, context}) async {
    print("get数据请求开始===>url =${path}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options options = Options(headers: {
      // HttpHeaders.acceptHeader: "accept: application/json;charset=UTF-8",
      "Cookie": "JSESSIONID=" + prefs.getString("JSESSIONID")
    });
    print("JSESSION=${prefs.getString("JSESSIONID")}");
    try {
      Response response =
          await Dio().get(path, queryParameters: params, options: options);
      print("Response->>>>>>>>>>>");
      if (response.data["code"] == 401) {
        showToast("Please log in",
            position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
        Router.navigatorKey.currentState
            .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
      }
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  static post(path, {data, params}) async {
    print("post数据请求开始url=${path} data= ${data}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options options = Options(headers: {
      // HttpHeaders.acceptHeader: "accept: application/json;charset=UTF-8",
      "Cookie": "JSESSIONID=" + prefs.getString("JSESSIONID")
    });
    print("JSESSIONID=${prefs.getString("JSESSIONID")}");
    try {
      Response response = await Dio()
          .post(path, data: data, queryParameters: params, options: options);
      print("Response->>>>>>>>>>>");
      if (response.data["code"] == 401) {
        showToast("Please log in",
            position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
        // Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
        Router.navigatorKey.currentState
            .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
      }
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
