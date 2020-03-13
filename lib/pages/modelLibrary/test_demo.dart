import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body: Container(
        width:MediaQuery.of(context).size.width,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.red
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.red
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.red
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
          Container(
            width: 50,
            height: 50,
            color:Colors.grey
          ),
        ],),
      )
    );
  }
}
