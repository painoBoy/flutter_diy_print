/*
 * @Author: your name
 * @Date: 2020-02-20 10:30:58
 * @LastEditTime: 2020-03-03 15:05:42
 * @LastEditors: Please set LastEditors
 * @Description: 封装shared_preferences 方法
 * @FilePath: /diy_3d_print/lib/utils/Storage.dart
 */

import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static Future<void> setString(String key,value) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       sp.setString(key, value);
  }
  static Future<String> getString(key) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       return sp.getString(key);
  }
  static Future<void> remove(key) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       sp.remove(key);
  }
  static Future<void> clear() async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       sp.clear();
  }


}
