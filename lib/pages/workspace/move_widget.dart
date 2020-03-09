import 'package:flutter/material.dart';
import '../../utils/ScreenAdapter.dart';

class MoveWidget extends StatefulWidget {
  @override
  _MoveWidgetState createState() => _MoveWidgetState();
}

class _MoveWidgetState extends State<MoveWidget> with SingleTickerProviderStateMixin {
  List _direction = ["X", "Y", "Z"]; //x、y、z轴
  int _directionIndex = 0;
  int _distance = 5;
  double _iconSize = 100;
  //切换轴
  changeDirection() {
    if (_directionIndex == 2) {
      setState(() {
        _directionIndex = 0;
      });
    } else {
      setState(() {
        _directionIndex = _directionIndex + 1;
        
      });
    }
    print(_direction[_directionIndex]);
  }

  //切换距离
  changeDistance() {
    if (_distance == 5) {
      setState(() {
        _distance = 10;
      });
    } else {
      setState(() {
        _distance = 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.fromLTRB(
            0, ScreenAdapter.height(40), 0, ScreenAdapter.height(40)),
        margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      
                    },
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      vsync: this,
                      child: Icon(
                        Icons.add_circle_outline,
                        size: ScreenAdapter.size(100),
                      ),
                    )
                  ),
                  Icon(Icons.remove_circle_outline,
                      size: ScreenAdapter.size(100))
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("移动轴"),
                  // FlatButton.icon(
                  //     onPressed: null,
                  //     icon: Icon(Icons.swap_calls, size: ScreenAdapter.size(150)),
                  //     label: Text("切换Y轴"))
                  Container(
                    width: ScreenAdapter.width(200),
                    height: ScreenAdapter.width(200),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.width(200)),
                        border: Border.all(
                          width: ScreenAdapter.width(4),
                          color: Colors.black,
                        )),
                    child: InkWell(
                      onTap: changeDirection,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${_direction[_directionIndex]}",
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(50),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _directionIndex == 2
                                  ? "点击切换X轴"
                                  : "点击切换${_direction[_directionIndex + 1]}轴",
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(15),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  )
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Icon(Icons.filter_list, size: ScreenAdapter.size(80)),
                  Container(
                    width: ScreenAdapter.width(90),
                    height: ScreenAdapter.width(90),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.width(90)),
                        border: Border.all(
                          width: ScreenAdapter.width(5),
                          color: Colors.black,
                        )),
                    child: InkWell(
                      onTap: changeDistance,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${_distance}mm",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(18),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                  Icon(Icons.refresh, size: ScreenAdapter.size(100))
                ]),
          ],
        ));
  }
}
