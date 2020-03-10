import 'package:flutter/material.dart';
import 'dart:async';

class AnimateButton extends StatefulWidget {
  AnimateButton(
      {Key key,
      @required this.size,
      this.icon,
      this.startColor,
      this.endColor,
      this.callback})
      : super(key: key);
  final double size;
  final VoidCallback callback;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  @override
  _AnimateButtonState createState() => _AnimateButtonState();
}

class _AnimateButtonState extends State<AnimateButton>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;
  Color _curColor;

  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;
  Animation<double> curAnimation;
  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 60));

    _curColor = Colors.grey[100];
    _animation1 = Tween(begin: 1.0, end: 0.0).animate(_controller1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.forward(from: 0);
          curAnimation = _animation2;
          _curColor = Colors.redAccent;
        }
      });

    _animation2 = Tween(begin: 0.0, end: 1.2).animate(_controller2)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller3.forward(from: 0);
          curAnimation = _animation3;
        }
      });

    _animation3 = Tween(begin: 1.2, end: 1.0).animate(_controller3)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.callback != null) {
          widget.callback();
        }
      });

       curAnimation = _animation1;
      
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){_controller1.forward(from: 0);},
        child: Icon(
          Icons.favorite,
          size: widget.size * curAnimation.value,
          color: _curColor,
        ),
          ),
      );
  }
}

class AnimatedUnFav extends StatefulWidget {
  AnimatedUnFav({Key key,@required this.size}) : super(key: key);
  final double size;
  _AnimatedUnFavState createState() => _AnimatedUnFavState();
}

class _AnimatedUnFavState extends State<AnimatedUnFav> with TickerProviderStateMixin {
  AnimationController _controller_1;
  AnimationController _controller_2;
  Animation<double> _animation_1;
  Animation<double> _animation_2;
  Animation<double> curAnimation;
  Color curColor;
  @override
  void initState() {
    super.initState();
    curColor=Colors.redAccent;
    _controller_1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _controller_2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation_1 = Tween(begin: 1.0, end: 1.2).animate(_controller_1)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller_2.forward(from: 0);
          setState(() {
            curAnimation = _animation_2;
            curColor=Colors.grey[100];
          });
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _animation_2 = Tween(begin: 1.2, end: 1.0).animate(_controller_2)
      ..addListener(() {
        setState(() {});
      });
    curAnimation = _animation_1;
    
  }

  @override
  Widget build(BuildContext context) {
    // rpx = MediaQuery.of(context).size.width / 750;
    return Center(
        child: GestureDetector(
          onTap: (){_controller_1.forward(from: 0);},
          child: Icon(
              Icons.favorite,
              size: widget.size * curAnimation.value,
              color: curColor,
            )
        ),);
  }
}