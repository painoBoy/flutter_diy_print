import 'package:flutter/material.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 2),(){
      print("启动中...");
      Navigator.of(context).pushReplacementNamed("log");
    });
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/splash.jpg"),
    );
  }
}