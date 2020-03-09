/*
 * @Author: your name
 * @Date: 2020-02-17 10:38:59
 * @LastEditTime : 2020-02-17 10:45:14
 * @LastEditors  : Please set LastEditors
 * @Description: 封装一层Screen使用方法
 * @FilePath: /diy_3d_print/lib/utils/ScreenAdapter.dart
 */


import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdapter{

  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }
  static height(double value){
     return ScreenUtil.getInstance().setHeight(value);
  }
  static width(double value){
      return ScreenUtil.getInstance().setWidth(value);
  }
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  static getScreenPxHeight(){
    return ScreenUtil.screenHeight;
  }
  static getScreenPxWidth(){
    return ScreenUtil.screenWidth;
  }

  static size(double value){
   return ScreenUtil.getInstance().setSp(value);  
  }

  // ScreenUtil.screenHeight 
}
