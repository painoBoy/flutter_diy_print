import 'package:flutter/material.dart';
import '../utils/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../pages/provider/printerParams.dart';
import 'package:oktoast/oktoast.dart';

class HotBedSlider extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final callback1;
  final callback2;

  HotBedSlider(
      {this.width = 240,
      this.height = 120,
      this.color = Colors.black,
      this.callback1,
      this.callback2});

  @override
  _HotBedSliderState createState() => _HotBedSliderState();
}

class _HotBedSliderState extends State<HotBedSlider> {
  double _customInt = 240 / 100;
  double _dragPosition = 0;
  double _dragPercentage = 0;
  TextEditingController _tempController = TextEditingController();
  void _updateDragPosition(Offset val) {
    double newDragPosition = 0;
    if (val.dx <= 0) {
      newDragPosition = 0;
    } else if (val.dx >= widget.width) {
      newDragPosition = widget.width;
    } else {
      newDragPosition = val.dx;
    }
    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.width;
    });
    int _tempData = (_dragPercentage * 100).round();
    //传递父组件温度值
    widget.callback1(_tempData.toDouble());
    Provider.of<NozzleWarm>(context).changeHotBedWarm(_tempData.toDouble());
    _tempController.text =
        Provider.of<NozzleWarm>(context).hotBedWarm.round().toString();
    if ((_dragPercentage * 100).round() > 90) {
      Provider.of<NozzleWarm>(context).changeTemValue2(220.0);
    } else if ((_dragPercentage * 100).round() < 5) {
      Provider.of<NozzleWarm>(context).changeTemValue2(5.0);
    } else {
      Provider.of<NozzleWarm>(context).changeTemValue2(
          _customInt * Provider.of<NozzleWarm>(context).hotBedWarm);
    }
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.localPosition);
    _updateDragPosition(offset);
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(start.localPosition);
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    setState(() {});
  }

  void _changeInput(double val) {
    if (val.toInt() > 100) {
      showToast("The setting value must be lower than 100",
          position: ToastPosition.bottom, backgroundColor: Colors.grey[500]);
      return;
    } else if (val.toInt() > 90) {
      double _temp = double.parse(_tempController.text);
      Provider.of<NozzleWarm>(context).changeHotBedWarm(_temp);
      Provider.of<NozzleWarm>(context).changeTemValue2(220.0);
    } else if (val.toInt() < 2) {
      double _temp = double.parse(_tempController.text);
      Provider.of<NozzleWarm>(context).changeHotBedWarm(_temp);
      Provider.of<NozzleWarm>(context).changeTemValue2(5.0);
    } else {
      double _temp = double.parse(_tempController.text);
      Provider.of<NozzleWarm>(context).changeHotBedWarm(_temp);
     Provider.of<NozzleWarm>(context).changeTemValue2(_customInt * Provider.of<NozzleWarm>(context).hotBedWarm);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(Duration.zero, () {
      _tempController.text =
          Provider.of<NozzleWarm>(context).hotBedWarm.round().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/workspace/backgroud.png"),
                  fit: BoxFit.fill)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("0℃", style: TextStyle(fontSize: 10)),
                          Text("50℃", style: TextStyle(fontSize: 10)),
                          Text("100℃", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragUpdate: (DragUpdateDetails update) =>
                          _onDragUpdate(context, update),
                      onHorizontalDragStart: (DragStartDetails start) =>
                          _onDragStart(context, start),
                      onHorizontalDragEnd: (DragEndDetails end) =>
                          _onDragEnd(context, end),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10),
                              width: widget.width,
                              child: Image.asset(
                                "assets/images/workspace/line.png",
                                fit: BoxFit.cover,
                              )),
                          Positioned(
                              left: Provider.of<NozzleWarm>(context).tempValue2,
                              top: 10,
                              child: Container(
                                  width: ScreenAdapter.width(40),
                                  height: ScreenAdapter.width(40),
                                  child: Image.asset(
                                      "assets/images/workspace/slider_btn.png"))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: ScreenAdapter.width(95),
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: ScreenAdapter.width(3),
                            color: Color(0xFFF79432)),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      onChanged: (value) {
                        _changeInput(double.parse(value));
                      },
                      maxLength: 3,
                      style: TextStyle(fontSize: ScreenAdapter.size(22)),
                      maxLines: 1,
                      controller: _tempController,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      cursorColor: Color(0xFFF79432), //光标颜色
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Positioned(
                      top: 4,
                      right: 4,
                      child: Text(
                        "℃",
                        style: TextStyle(color: Colors.black54),
                      ))
                ],
              ),
              InkWell(
                onTap: () {
                  widget.callback2();
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: ScreenAdapter.width(80),
                  height: ScreenAdapter.width(80),
                  child: Image.asset("assets/images/workspace/okBtn.png"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
