


import '../pages/account/message_list.dart';

import '../pages/login/forgot_password.dart';
import '../navigator.dart';
import '../pages/workspace/scan.dart';
import '../pages/login/log_page.dart';
import 'package:flutter/material.dart';
import '../pages/modelLibrary/modelLib_page.dart';
import '../pages/workspace/home_page.dart';
import '../pages/login/register_page.dart';
import '../pages/account/setting_page.dart';
import '../pages/account/set_userInfo.dart';
import '../pages/account/sex_page.dart';
import '../pages/account/printer_manage.dart';
import '../pages/account/collection_page.dart';
import '../pages/account/printHistory_page.dart';
import '../pages/account/account_setting.dart';
import '../pages/account/help_suggest.dart';
import '../pages/account/userInfo_page.dart';
import '../pages/modelLibrary/model_detail.dart';
import '../pages/modelLibrary/modelList_page.dart';
import '../pages/modelLibrary/searchModel_page.dart';
import '../pages/modelLibrary/searchResult_page.dart';
import '../utils/Storage.dart';

//配置路由
final routes = {
  '/': (context) => LogPage(),
  "/tabs": (BuildContext context) => NavigatorBarPage(),
  "/home": (BuildContext context) => Home(),
  "/account": (BuildContext context) => SettingPage(),
  "log": (BuildContext context) => LogPage(),
  "register": (BuildContext context) => RegisterPage(),
  "/forgotpassword": (BuildContext context) => ForgotPasswordPage(),
  "/modelCollect": (BuildContext context) => ModelCollectionPage(),
  "/printHistory": (BuildContext context) => PrintHistoryPage(),
  "/message": (BuildContext context) => MessageListPage(),
  "/setting": (BuildContext context) => AccountSettingPage(),
  "/help": (BuildContext context) => HelpSugPage(),
  "/userInfo": (BuildContext context) => UserInfoPage(),
  "/setUserInfo": (BuildContext context) => SetUserInfoPage(),
  "/setUserSex": (BuildContext context) => SexOptionPage(),
  "/printerManage": (BuildContext context) => PrinterManage(),
  "/scan":(BuildContext context)=> ScanWidget(),
  "/modelLib":(BuildContext context)=> ModelLibraryPage(),
  "/modelDetail":(BuildContext context,{arguments})=> ModelDetailPage(arguments: arguments),
  "/modelList":(BuildContext context,{arguments})=> ModelListPage(arguments: arguments),
  "/searchModel":(BuildContext context,)=> SearchModelPage(),
  "/searchResult":(BuildContext context,{arguments})=> SearchResultPage(arguments:arguments),

};


//固定写法
var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
